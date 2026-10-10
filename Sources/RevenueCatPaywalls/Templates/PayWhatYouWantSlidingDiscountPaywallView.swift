import SwiftUI
import RevenueCat

public struct PayWhatYouWantSlidingDiscountPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var sliderValue: Double = 1.0 // 0: Bronze, 1: Silver, 2: Gold, 3: Platinum
    
    let tiers: [(title: String, price: String, perk: String, icon: String)] = [
        ("Bronze Supporter", "$19 / yr", "Essential Pro Features", "shield"),
        ("Silver Backer", "$39 / yr", "All Pro + Priority AI", "shield.lefthalf.filled"),
        ("Gold Champion", "$59 / yr", "Full Pro + VIP Beta Channel", "shield.fill"),
        ("Platinum Patron", "$99 / yr", "Lifetime Supporter Hall of Fame", "crown.fill")
    ]
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Choose What Feels Fair",
            appSubtitle: "We believe great software should be accessible. Pay what you want to support development.",
            primaryThemeColor: Color(red: 0.20, green: 0.75, blue: 0.95),
            secondaryThemeColor: Color(red: 0.55, green: 0.35, blue: 0.95)
        ),
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    private var currentTierIndex: Int {
        min(max(Int(round(sliderValue)), 0), tiers.count - 1)
    }
    
    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.07, blue: 0.11)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Slider & Fair Contribution Overview
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        interactiveSliderCard
                        headlineSection
                        supporterValuesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Fair Tier CTA + Legal Footer)
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
                        .fill(Color(red: 0.08, green: 0.09, blue: 0.15).opacity(0.96))
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
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("SLIDING SCALE DISCOUNT")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
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
    
    // MARK: - Interactive Slider Card
    private var interactiveSliderCard: some View {
        let tier = tiers[currentTierIndex]
        
        return VStack(spacing: 16) {
            HStack {
                Image(systemName: tier.icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(configuration.primaryThemeColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(tier.title)
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.white)
                    Text(tier.perk)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Text(tier.price)
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(configuration.secondaryThemeColor)
            }
            
            // Slider Control
            VStack(spacing: 6) {
                Slider(value: $sliderValue, in: 0...3, step: 1)
                    .tint(configuration.primaryThemeColor)
                
                HStack {
                    Text("Budget ($19)")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                    Spacer()
                    Text("Standard ($39)")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(configuration.primaryThemeColor)
                    Spacer()
                    Text("Patron ($99)")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(configuration.secondaryThemeColor)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.10, green: 0.12, blue: 0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(configuration.primaryThemeColor.opacity(0.35), lineWidth: 1)
                )
        )
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
                .foregroundColor(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    // MARK: - Supporter Values
    private var supporterValuesSection: some View {
        VStack(spacing: 10) {
            valueRow(icon: "heart.circle.fill", title: "Accessible For Everyone", desc: "Students, artists, and independent workers can contribute whatever matches their current finances.")
            valueRow(icon: "shield.checkerboard", title: "Same Core Pro Power", desc: "No artificial crippling. All tiers enjoy core pro unlocked features without limits.")
            valueRow(icon: "leaf.fill", title: "10% Donated To Open Source", desc: "A portion of every supporter pledge is redistributed to foundational open-source libraries.")
        }
    }
    
    private func valueRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(configuration.primaryThemeColor)
                .frame(width: 32, height: 32)
                .background(Circle().fill(configuration.primaryThemeColor.opacity(0.18)))
            
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
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Confirm My Custom Support")
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
    PayWhatYouWantSlidingDiscountPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
