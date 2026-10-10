import SwiftUI

public struct CyberpunkPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var features: [PaywallFeatureItem]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
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
            // High contrast deep background
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Cyber Hero Header
                        VStack(spacing: 8) {
                            HStack(spacing: 6) {
                                Circle().fill(configuration.primaryThemeColor).frame(width: 8, height: 8)
                                Text("SYSTEM: READY_FOR_UPGRADE")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(configuration.primaryThemeColor)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(configuration.primaryThemeColor.opacity(0.12), in: Capsule())
                            
                            Text(configuration.appTitle)
                                .font(.system(size: 28, weight: .black, design: .monospaced))
                                .foregroundColor(.white)
                            
                            Text(configuration.appSubtitle)
                                .font(.system(size: 13, weight: .regular, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 14)
                        }
                        .padding(.top, 4)
                        
                        // Cyber Feature Matrix
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
                        
                        // Plans with Brutalist Border
                        VStack(spacing: 10) {
                            ForEach(manager.packages) { package in
                                let isSelected = manager.selectedPackage?.id == package.id
                                
                                Button(action: {
                                    manager.selectPackage(package)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack(spacing: 6) {
                                                Text(package.title.uppercased())
                                                    .font(.system(size: 14, weight: .black, design: .monospaced))
                                                    .foregroundColor(isSelected ? configuration.primaryThemeColor : .white)
                                                
                                                if let badge = package.badgeText {
                                                    Text("[\(badge)]")
                                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                                        .foregroundColor(configuration.secondaryThemeColor)
                                                }
                                            }
                                            
                                            if let weekly = package.weeklyEquivalentString {
                                                Text(weekly)
                                                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                                                    .foregroundColor(.white.opacity(0.6))
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Text(package.localizedPriceString)
                                            .font(.system(size: 18, weight: .black, design: .monospaced))
                                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .white)
                                    }
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.08) : Color.white.opacity(0.02))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.15), lineWidth: isSelected ? 2 : 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        // Cyber CTA Button
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
                            .frame(height: 52)
                        }
                        .disabled(manager.isPurchasing)
                        .padding(.top, 4)
                        
                        // Legal Footer
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
}

// MARK: - Canvas Preview

#Preview("Cyberpunk Paywall") {
    CyberpunkPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
