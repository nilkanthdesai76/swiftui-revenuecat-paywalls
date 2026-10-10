import SwiftUI

public struct MediaWaveformPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var features: [PaywallFeatureItem]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var wavePhase: Double = 0.0
    
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
            // Dark studio background
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        // Title
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
                        
                        // Pulsing Waveform Visualizer
                        waveformVisualizer
                            .frame(height: 70)
                            .padding(.horizontal, 10)
                        
                        // Features
                        featuresGrid
                        
                        // Plans
                        plansSection
                        
                        // CTA
                        ctaButtonSection
                        
                        // Legal Footer
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
                        .padding(.top, 4)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                }
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
    
    // MARK: - Waveform Visualizer
    
    private var waveformVisualizer: some View {
        HStack(spacing: 4) {
            ForEach(0..<24, id: \.self) { i in
                let normalized = sin(Double(i) * 0.4 + (wavePhase * .pi))
                let height = max(12.0, abs(normalized) * 60.0 + 8.0)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(height: CGFloat(height))
                    .shadow(color: configuration.primaryThemeColor.opacity(0.3), radius: 3)
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
    
    // MARK: - Plans
    
    private var plansSection: some View {
        VStack(spacing: 10) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.2), lineWidth: 2)
                                .frame(width: 20, height: 20)
                            
                            if isSelected {
                                Circle()
                                    .fill(configuration.primaryThemeColor)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                if let badge = package.badgeText {
                                    DiscountBadgeView(text: badge, backgroundColor: configuration.primaryThemeColor, textColor: .black)
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.55))
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isSelected ? Color.white.opacity(0.10) : Color.white.opacity(0.03))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
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
            .frame(height: 54)
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
