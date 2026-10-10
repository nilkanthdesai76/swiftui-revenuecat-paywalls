import SwiftUI

public struct CompactSheetPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Unlock Full Access",
            appSubtitle: "Continue using all premium features without restrictions",
            appIconSystemName: "lock.open.trianglebadge.exclamationmark.fill",
            primaryThemeColor: Color(red: 0.18, green: 0.65, blue: 0.45)
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
        VStack(spacing: 18) {
            // Drag Indicator
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 10)
            
            // Close button bar
            HStack {
                Spacer()
                Button(action: {
                    HapticFeedback.light()
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Color(UIColor.secondarySystemBackground), in: Circle())
                }
            }
            .padding(.horizontal, 20)
            
            // Icon & Title
            VStack(spacing: 8) {
                Image(systemName: configuration.appIconSystemName)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(configuration.primaryThemeColor)
                
                Text(configuration.appTitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(configuration.appSubtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Plan Cards (Compact Row)
            HStack(spacing: 12) {
                ForEach(manager.packages.filter { $0.kind == .annual || $0.kind == .monthly }) { package in
                    let isSelected = manager.selectedPackage?.id == package.id
                    
                    Button(action: {
                        manager.selectPackage(package)
                    }) {
                        VStack(spacing: 4) {
                            if let badge = package.badgeText {
                                Text(badge)
                                    .font(.system(size: 9.5, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(configuration.primaryThemeColor, in: Capsule())
                            } else {
                                Text("STANDARD")
                                    .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                            }
                            
                            Text(package.kind == .annual ? "Annual" : "Monthly")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text(package.localizedPriceString)
                                .font(.system(size: 17, weight: .black, design: .rounded))
                                .foregroundColor(isSelected ? configuration.primaryThemeColor : .primary)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(isSelected ? configuration.primaryThemeColor.opacity(0.1) : Color(UIColor.secondarySystemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(isSelected ? configuration.primaryThemeColor : Color.clear, lineWidth: 2)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            
            // Fast 1-Tap CTA
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
                        .fill(configuration.primaryThemeColor)
                    
                    if manager.isPurchasing {
                        ProgressView().tint(.white)
                    } else {
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Continue")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 50)
            }
            .disabled(manager.isPurchasing)
            .padding(.horizontal, 20)
            
            // Compact Legal Links
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
            .padding(.bottom, 16)
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
}

// MARK: - Canvas Preview

#Preview("Compact Sheet Paywall") {
    CompactSheetPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
