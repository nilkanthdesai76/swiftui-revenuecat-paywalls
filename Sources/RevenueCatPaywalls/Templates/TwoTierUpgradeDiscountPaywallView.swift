import SwiftUI

public struct TwoTierUpgradeDiscountPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Upgrade to Lifetime VIP",
            appSubtitle: "Pay just once, unlock all future updates forever, and skip recurring fees.",
            primaryThemeColor: Color(red: 0.15, green: 0.55, blue: 0.95),
            secondaryThemeColor: Color(red: 0.95, green: 0.65, blue: 0.15)
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
            Color.appSystemBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Comparison Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headlineSection
                        
                        // Value Math Comparison Card
                        mathComparisonCard
                        
                        // Lifetime Perks
                        lifetimePerksList
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + CTA + Legal Footer)
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
                        .fill(Color.appSecondaryGroupedBackground)
                        .overlay(
                            Rectangle()
                                .fill(Color.secondary.opacity(0.12))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
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
            HStack(spacing: 6) {
                Image(systemName: "crown.fill")
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("SPECIAL VALUE UPGRADE")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(configuration.secondaryThemeColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(configuration.secondaryThemeColor.opacity(0.12), in: Capsule())
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color.secondary.opacity(0.12), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    // MARK: - Headline
    
    private var headlineSection: some View {
        VStack(spacing: 6) {
            Text(configuration.appTitle)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Math Comparison Card
    
    private var mathComparisonCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("THE VALUE BREAKDOWN")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(.secondary)
                Spacer()
                Text("SAVE OVER $70")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(configuration.secondaryThemeColor)
            }
            
            HStack(spacing: 14) {
                // Annual recurring cost over 3 years
                VStack(spacing: 4) {
                    Text("3-Year Subscriptions")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text("$119.97")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .strikethrough(true, color: .red)
                        .foregroundColor(.secondary)
                    
                    Text("($39.99/year renewing)")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.appSecondarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                // Lifetime one-time cost
                VStack(spacing: 4) {
                    Text("Lifetime VIP Pass")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(configuration.secondaryThemeColor)
                        .lineLimit(1)
                    
                    Text("$49.99")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Pay once • Yours forever")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color.green)
                        .lineLimit(1)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(configuration.secondaryThemeColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(configuration.secondaryThemeColor.opacity(0.4), lineWidth: 1.5)
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appSecondarySystemBackground.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Perks
    
    private var lifetimePerksList: some View {
        VStack(spacing: 10) {
            perkRow(icon: "infinity", text: "Zero recurring charges ever billed to your Apple ID")
            perkRow(icon: "sparkles", text: "Free entitlement to all major v2.0, v3.0, and future releases")
            perkRow(icon: "familylinks", text: "Compatible with Apple Family Sharing across up to 5 members")
        }
    }
    
    private func perkRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(configuration.primaryThemeColor)
                .frame(width: 22)
            
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    // MARK: - Plans (Static Bottom Dock)
    
    private var planSelectionCards: some View {
        VStack(spacing: 8) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .secondary.opacity(0.35))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    DiscountBadgeView(text: badge, backgroundColor: configuration.secondaryThemeColor)
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            } else if let trial = package.introTrialText {
                                Text(trial)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(configuration.primaryThemeColor)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(isSelected ? configuration.primaryThemeColor : .primary)
                                .lineLimit(1)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.1) : Color.appSystemBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.secondary.opacity(0.12), lineWidth: isSelected ? 2 : 1)
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
                    .fill(configuration.primaryThemeColor)
                    .shadow(color: configuration.primaryThemeColor.opacity(0.4), radius: 12, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(manager.selectedPackage?.kind == .lifetime ? "Claim Lifetime VIP" : "Continue with Selected Plan")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 14))
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

#Preview("Two Tier Upgrade Discount Paywall") {
    TwoTierUpgradeDiscountPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
