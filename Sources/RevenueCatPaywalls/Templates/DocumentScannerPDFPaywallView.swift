import SwiftUI
import RevenueCat

public struct DocumentScannerPDFPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var scanLaserOffset: CGFloat = -100
    @State private var highlightedWordIndex: Int = 0
    @State private var pulseGlow: CGFloat = 1.0
    
    let sampleOCRText = [
        "INVOICE #9204", "TAX EXEMPT: YES", "TOTAL: $1,420.00",
        "STATUS: OCR EXTRACTED", "SMART OCR: 99.8% ACCURACY"
    ]
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Scanner Pro & PDF Studio",
            appSubtitle: "Digitize receipts, export 4K searchable PDFs, and extract OCR text instantly.",
            primaryThemeColor: Color(red: 0.12, green: 0.58, blue: 0.95),
            secondaryThemeColor: Color(red: 0.05, green: 0.85, blue: 0.65)
        ),
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Scanner Demo & Features
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        scannerInteractivePreview
                        headlineSection
                        scannerFeatureCards
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Scan CTA + Legal Footer)
                VStack(spacing: 12) {
                    planSelectionCards
                    ctaButtonSection
                    
                    PaywallLegalFooterView(
                        termsURL: configuration.termsURL,
                        privacyURL: configuration.privacyURL,
                        onRestore: {
                            Task {
                                if await manager.restorePurchases() {
                                    onPurchaseSuccess?()
                                }
                            }
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 12)
                .background(
                    Rectangle()
                        .fill(Color(red: 0.09, green: 0.11, blue: 0.16).opacity(0.96))
                        .overlay(
                            Rectangle()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                scanLaserOffset = 95
            }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulseGlow = 1.15
            }
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                highlightedWordIndex = (highlightedWordIndex + 1) % sampleOCRText.count
            }
        }
        .task {
            if !manager.isMockMode && manager.packages.isEmpty {
                await manager.loadOfferings()
            }
        }
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Header
    private var headerBar: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("UNLIMITED SCANNER PASS")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .overlay(Capsule().stroke(configuration.primaryThemeColor.opacity(0.4), lineWidth: 1))
            )
            
            Spacer()
            
            Button {
                Task {
                    if await manager.restorePurchases() {
                        onPurchaseSuccess?()
                    }
                }
            } label: {
                Text("Restore")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }
    
    // MARK: - Scanner Interactive Preview
    private var scannerInteractivePreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.12, green: 0.15, blue: 0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(configuration.primaryThemeColor.opacity(0.3), lineWidth: 1)
                )
            
            VStack(spacing: 12) {
                // Document Sheet Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Circle().fill(Color.red.opacity(0.8)).frame(width: 8, height: 8)
                            Circle().fill(Color.yellow.opacity(0.8)).frame(width: 8, height: 8)
                            Circle().fill(Color.green.opacity(0.8)).frame(width: 8, height: 8)
                            Spacer()
                            Text("PAGE 1 OF 1 • 300 DPI")
                                .font(.system(size: 8, weight: .bold, design: .monospaced))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        
                        Divider().background(Color.black.opacity(0.1))
                        
                        ForEach(0..<sampleOCRText.count, id: \.self) { idx in
                            HStack {
                                Text(sampleOCRText[idx])
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(idx == highlightedWordIndex ? .white : .black.opacity(0.75))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(idx == highlightedWordIndex ? configuration.primaryThemeColor : Color.clear)
                                    )
                                Spacer()
                                if idx == highlightedWordIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(configuration.secondaryThemeColor)
                                }
                            }
                        }
                    }
                    .padding(12)
                    
                    // Moving Cyan Laser Beam
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    configuration.secondaryThemeColor.opacity(0),
                                    configuration.secondaryThemeColor.opacity(0.9),
                                    configuration.secondaryThemeColor.opacity(0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 4)
                        .shadow(color: configuration.secondaryThemeColor, radius: 6)
                        .offset(y: scanLaserOffset)
                }
                .frame(height: 160)
                .clipped()
                
                // OCR Badge Row
                HStack(spacing: 8) {
                    Label("Auto Edge Detection", systemImage: "crop")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(configuration.secondaryThemeColor)
                            .frame(width: 6, height: 6)
                            .scaleEffect(pulseGlow)
                        Text("Live OCR Active")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(configuration.secondaryThemeColor)
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(14)
        }
        .frame(height: 220)
    }
    
    // MARK: - Headline
    private var headlineSection: some View {
        VStack(spacing: 8) {
            Text(configuration.appTitle)
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    // MARK: - Feature Cards
    private var scannerFeatureCards: some View {
        VStack(spacing: 10) {
            scannerFeatureRow(icon: "doc.text.magnifyingglass", title: "Smart OCR Text Extraction", desc: "Copy text instantly from any physical document or receipt in 40+ languages.")
            scannerFeatureRow(icon: "signature", title: "Digital Signatures & Watermarks", desc: "Sign legal contracts on device and protect files with custom watermarks.")
            scannerFeatureRow(icon: "lock.shield.fill", title: "Encrypted Cloud & Face ID Vault", desc: "Protect confidential tax documents with 256-bit AES vault encryption.")
            scannerFeatureRow(icon: "square.and.arrow.up.fill", title: "Unlimited Multi-Page PDF Export", desc: "No page limits, watermark-free high resolution color and black/white export.")
        }
    }
    
    private func scannerFeatureRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(configuration.primaryThemeColor)
                .frame(width: 32, height: 32)
                .background(Circle().fill(configuration.primaryThemeColor.opacity(0.15)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                Text(desc)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06), lineWidth: 1))
        )
    }
    
    // MARK: - Plan Selection Cards
    private var planSelectionCards: some View {
        VStack(spacing: 8) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .white.opacity(0.35))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    DiscountBadgeView(
                                        text: badge,
                                        backgroundColor: configuration.primaryThemeColor,
                                        textColor: .white
                                    )
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.white.opacity(0.65))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            } else if let trial = package.introTrialText {
                                Text(trial)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color.green)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 15, weight: .heavy))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.white.opacity(0.55))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.18) : Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.08), lineWidth: isSelected ? 1.5 : 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - CTA Button
    private var ctaButtonSection: some View {
        Button(action: {
            HapticFeedback.medium()
            Task {
                if await manager.purchaseSelected() {
                    onPurchaseSuccess?()
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.35), radius: 8, y: 4)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.viewfinder")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Unlock Unlimited Scans")
                            .font(.system(size: 15, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .disabled(manager.isPurchasing || manager.selectedPackage == nil)
    }
}


#if DEBUG
#Preview {
    DocumentScannerPDFPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
