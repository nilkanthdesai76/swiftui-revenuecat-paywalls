import SwiftUI

public struct WinBackRetentionPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Wait! A Special Note",
            appSubtitle: "We want everyone to be able to enjoy Pro, regardless of budget.",
            primaryThemeColor: Color(red: 0.20, green: 0.65, blue: 0.50),
            secondaryThemeColor: Color(red: 0.15, green: 0.45, blue: 0.85)
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
                
                // Top Scrollable Personal Note
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headlineSection
                        
                        // Personal Developer Note Card
                        developerNoteCard
                        
                        guaranteeCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Friendly CTA + Legal Footer)
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
                Image(systemName: "heart.fill")
                    .foregroundColor(configuration.primaryThemeColor)
                Text("COMMUNITY GRANT")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(configuration.primaryThemeColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(configuration.primaryThemeColor.opacity(0.12), in: Capsule())
            
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
    
    // MARK: - Developer Note Card
    
    private var developerNoteCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(configuration.primaryThemeColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(configuration.primaryThemeColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("From the Indie Developer")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Building handcrafted software for you")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("50% OFF")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(configuration.primaryThemeColor, in: Capsule())
            }
            
            Text("“I know subscriptions add up quickly. If price was the only thing holding you back today, please take this 50% Community Grant on me. You get the complete Pro experience with every feature unlocked.”")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.primary.opacity(0.85))
                .lineSpacing(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.appSecondarySystemBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(configuration.primaryThemeColor.opacity(0.3), lineWidth: 1.5)
                )
        )
    }
    
    // MARK: - Guarantee
    
    private var guaranteeCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 20))
                .foregroundColor(configuration.primaryThemeColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("No Hidden Terms or Surprise Price Hikes")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Manage directly via your Apple ID. Cancel anytime in 1 tap.")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.appSecondarySystemBackground.opacity(0.5))
        )
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
                                    DiscountBadgeView(text: badge, backgroundColor: configuration.primaryThemeColor)
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
                        Text("Accept Community Grant")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "heart.fill")
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

#Preview("Win Back Retention Paywall") {
    WinBackRetentionPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
