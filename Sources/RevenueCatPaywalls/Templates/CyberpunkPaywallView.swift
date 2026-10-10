import SwiftUI

public struct CyberpunkPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var features: [PaywallFeatureItem]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var scanLineOffset: CGFloat = -150
    @State private var terminalCursorVisible: Bool = true
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "DEV_ROOT_ACCESS",
            appSubtitle: "Uncap local hardware limits, CLI runtimes, and cluster pipelines",
            appIconSystemName: "terminal.fill",
            primaryThemeColor: Color(red: 0.1, green: 0.95, blue: 0.55),
            secondaryThemeColor: Color(red: 1.0, green: 0.2, blue: 0.6)
        ),
        features: [PaywallFeatureItem] = MockData.sampleCyberpunkFeatures,
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.features = features
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    public var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.07).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                PaywallHeaderView(
                    delaySeconds: configuration.closeDelaySeconds,
                    tintColor: configuration.primaryThemeColor,
                    onRestore: {
                        Task {
                            if await manager.restorePurchases() {
                                onPurchaseSuccess?()
                            }
                        }
                    },
                    onDismiss: onDismiss
                )
                
                // Top Scrollable Section
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        heroCyberHeader
                        cyberFeatureMatrix
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                
                // Static Bottom Dock (Plans + CTA + Legal Footer)
                VStack(spacing: 12) {
                    plansSection
                    ctaButtonSection
                    
                    PaywallLegalFooterView(
                        termsURL: configuration.termsURL,
                        privacyURL: configuration.privacyURL,
                        textColor: .white.opacity(0.5),
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
                        .fill(Color(red: 0.07, green: 0.07, blue: 0.09))
                        .overlay(
                            Rectangle()
                                .fill(configuration.primaryThemeColor.opacity(0.3))
                                .frame(height: 1.5),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                scanLineOffset = 150
            }
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                terminalCursorVisible.toggle()
            }
        }
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Hero Header
    
    private var heroCyberHeader: some View {
        VStack(spacing: 8) {
            // Scanning Status Pill with laser line
            ZStack {
                HStack(spacing: 6) {
                    Circle().fill(configuration.primaryThemeColor).frame(width: 8, height: 8)
                    Text("SYSTEM: READY_FOR_UPGRADE")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(configuration.primaryThemeColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(configuration.primaryThemeColor.opacity(0.12), in: Capsule())
                
                // Laser scan line
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 20, height: 2)
                    .offset(x: scanLineOffset)
            }
            .clipShape(Capsule())
            
            HStack(spacing: 4) {
                Text(configuration.appTitle)
                    .font(.system(size: 26, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                
                Text(terminalCursorVisible ? "_" : " ")
                    .font(.system(size: 26, weight: .black, design: .monospaced))
                    .foregroundColor(configuration.primaryThemeColor)
            }
            
            Text(configuration.appSubtitle)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 14)
        }
        .padding(.top, 2)
    }
    
    // MARK: - Cyber Features
    
    private var cyberFeatureMatrix: some View {
        VStack(spacing: 10) {
            ForEach(features) { item in
                HStack(spacing: 12) {
                    Image(systemName: item.icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(configuration.primaryThemeColor)
                        .frame(width: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        Text(item.subtitle)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(configuration.primaryThemeColor.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - Plans (Static Bottom Dock)
    
    private var plansSection: some View {
        VStack(spacing: 8) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        Text(isSelected ? "[x]" : "[ ]")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .white.opacity(0.4))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title.uppercased())
                                    .font(.system(size: 13, weight: .black, design: .monospaced))
                                    .foregroundColor(isSelected ? configuration.primaryThemeColor : .white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    Text("[\(badge)]")
                                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                                        .foregroundColor(configuration.secondaryThemeColor)
                                        .lineLimit(1)
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.6))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            } else if let trial = package.introTrialText {
                                Text(trial.uppercased())
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(configuration.secondaryThemeColor)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(isSelected ? configuration.primaryThemeColor : .white)
                                .lineLimit(1)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 9.5, weight: .regular, design: .monospaced))
                                .foregroundColor(.white.opacity(0.55))
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.12) : Color.white.opacity(0.02))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.12), lineWidth: isSelected ? 1.5 : 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - CTA
    
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
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(configuration.primaryThemeColor)
                    .shadow(color: configuration.primaryThemeColor.opacity(0.5), radius: 10, y: 3)
                
                if manager.isPurchasing {
                    ProgressView().tint(.black)
                } else {
                    HStack(spacing: 8) {
                        Text("> EXECUTE_UPGRADE")
                            .font(.system(size: 16, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 50)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Cyberpunk Paywall") {
    CyberpunkPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
