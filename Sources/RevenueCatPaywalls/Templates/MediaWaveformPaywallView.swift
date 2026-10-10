import SwiftUI

public struct MediaWaveformPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var features: [PaywallFeatureItem]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var wavePhase: Double = 0.0
    @State private var tappedBarIndex: Int? = nil
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Studio Master Access",
            appSubtitle: "Capture, master, and export lossless audio without limits",
            appIconSystemName: "waveform.path.badge.plus",
            primaryThemeColor: Color(red: 0.02, green: 0.85, blue: 0.83),
            secondaryThemeColor: Color(red: 0.58, green: 0.22, blue: 0.98)
        ),
        features: [PaywallFeatureItem] = MockData.sampleAudioFeatures,
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
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                PaywallHeaderView(
                    delaySeconds: configuration.closeDelaySeconds,
                    tintColor: .white,
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
                    VStack(spacing: 20) {
                        VStack(spacing: 6) {
                            Text(configuration.appTitle)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(configuration.appSubtitle)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        
                        // Interactive Pulsing Waveform Visualizer
                        waveformVisualizer
                            .frame(height: 70)
                            .padding(.horizontal, 10)
                        
                        featuresGrid
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
                        textColor: .white.opacity(0.55),
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
                        .fill(Color(red: 0.06, green: 0.06, blue: 0.08))
                        .overlay(
                            Rectangle()
                                .fill(LinearGradient(
                                    colors: [configuration.primaryThemeColor.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .preferredColorScheme(.dark)
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                wavePhase = 1.0
            }
        }
    }
    
    // MARK: - Interactive Waveform Visualizer
    
    private var waveformVisualizer: some View {
        HStack(spacing: 5) {
            ForEach(0..<22, id: \.self) { i in
                let isTapped = tappedBarIndex == i
                let normalized = sin(Double(i) * 0.4 + (wavePhase * .pi))
                let baseHeight = max(12.0, abs(normalized) * 60.0 + 8.0)
                let height = isTapped ? 68.0 : baseHeight
                
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                        tappedBarIndex = i
                    }
                    HapticFeedback.light()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        tappedBarIndex = nil
                    }
                }) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: isTapped ? [Color.white, configuration.primaryThemeColor] : [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: CGFloat(height))
                        .shadow(color: configuration.primaryThemeColor.opacity(isTapped ? 0.8 : 0.3), radius: isTapped ? 8 : 3)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Features Grid
    
    private var featuresGrid: some View {
        VStack(spacing: 12) {
            ForEach(features) { item in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(configuration.primaryThemeColor.opacity(0.18))
                            .frame(width: 38, height: 38)
                        
                        Image(systemName: item.icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(configuration.primaryThemeColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(item.subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.65))
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                )
            }
        }
    }
    
    // MARK: - Plans (Static Bottom Dock)
    
    private var plansSection: some View {
        HStack(spacing: 10) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 4) {
                            Text(package.kind == .annual ? "Annual" : package.kind == .monthly ? "Monthly" : "Lifetime")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if let badge = package.badgeText {
                                Text(badge)
                                    .font(.system(size: 8.5, weight: .black, design: .rounded))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(configuration.primaryThemeColor, in: Capsule())
                            }
                        }
                        
                        Text(package.localizedPriceString)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .white)
                        
                        Text(package.weeklyEquivalentString ?? package.periodSubtitle)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                            .lineLimit(1)
                    }
                    .padding(11)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.12) : Color.white.opacity(0.03))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
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
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.5), radius: 14, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Unlock Studio Access")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "headphones")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 52)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Media Waveform Paywall") {
    MediaWaveformPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
