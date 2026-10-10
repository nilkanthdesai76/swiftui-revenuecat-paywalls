import SwiftUI

public struct BentoPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var features: [PaywallFeatureItem]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var hoveredFeatureId: UUID?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Notchy Pro",
            appSubtitle: "Supercharge your Mac & iPhone workflow with next-gen tools",
            appIconSystemName: "sparkles"
        ),
        features: [PaywallFeatureItem] = MockData.sampleFeatures,
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
            // Radiant ambient background
            ambientBackground
            
            VStack(spacing: 0) {
                // Top navigation bar
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
                    VStack(spacing: 20) {
                        // Hero Header
                        heroHeaderSection
                        
                        // 2x2 Bento Feature Grid
                        bentoGridSection
                        
                        // Plan Selection Cards
                        planSelectionSection
                        
                        // CTA Button
                        ctaButtonSection
                        
                        // Legal Footer
                        PaywallLegalFooterView(
                            termsURL: configuration.termsURL,
                            privacyURL: configuration.privacyURL,
                            textColor: .white.opacity(0.65),
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
    }
    
    // MARK: - Ambient Background
    
    private var ambientBackground: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Subtle glowing orbs
            Circle()
                .fill(configuration.primaryThemeColor.opacity(0.35))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(configuration.secondaryThemeColor.opacity(0.25))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: 120, y: 150)
        }
    }
    
    // MARK: - Hero Header
    
    private var heroHeaderSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: configuration.primaryThemeColor.opacity(0.5), radius: 16, y: 6)
                
                Image(systemName: configuration.appIconSystemName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 8)
            
            Text(configuration.appTitle)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Bento Grid
    
    private var bentoGridSection: some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
        
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(features) { item in
                VStack(alignment: .leading, spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(configuration.primaryThemeColor.opacity(0.25))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: item.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text(item.title)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(item.subtitle)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.65))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - Plan Selection
    
    private var planSelectionSection: some View {
        VStack(spacing: 10) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        // Radio circle
                        ZStack {
                            Circle()
                                .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.3), lineWidth: 2)
                                .frame(width: 20, height: 20)
                            
                            if isSelected {
                                Circle()
                                    .fill(configuration.primaryThemeColor)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                        // Plan Details
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                if let badge = package.badgeText {
                                    DiscountBadgeView(
                                        text: badge,
                                        backgroundColor: configuration.primaryThemeColor
                                    )
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                            } else if let trial = package.introTrialText {
                                Text(trial)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(red: 0.3, green: 0.85, blue: 0.5))
                            }
                        }
                        
                        Spacer()
                        
                        // Price
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isSelected ? Color.white.opacity(0.12) : Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
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
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.4), radius: 12, y: 5)
                
                if manager.isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(ctaTitle)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 54)
        }
        .disabled(manager.isPurchasing)
        .padding(.top, 6)
    }
    
    private var ctaTitle: String {
        if let pkg = manager.selectedPackage, pkg.hasFreeTrial {
            return "Start 7-Day Free Trial"
        }
        return "Unlock Pro Access"
    }
}

// MARK: - Canvas Preview

#Preview("Bento Paywall - Dark Mode") {
    BentoPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
