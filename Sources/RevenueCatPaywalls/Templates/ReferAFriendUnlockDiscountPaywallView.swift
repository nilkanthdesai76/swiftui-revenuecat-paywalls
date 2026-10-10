import SwiftUI
import RevenueCat

public struct ReferAFriendUnlockDiscountPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var isCodeCopied: Bool = false
    let referralCode: String = "FRIEND50-VIP"
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Give 50%, Get 50%",
            appSubtitle: "Share your invite link with friends. Both of you unlock 50% off all annual & lifetime plans.",
            primaryThemeColor: Color(red: 0.15, green: 0.75, blue: 0.55),
            secondaryThemeColor: Color(red: 0.10, green: 0.60, blue: 0.95)
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
            Color(red: 0.05, green: 0.08, blue: 0.07)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Referral Card & Reward Mechanics
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        referralGiftCard
                        headlineSection
                        referralCodeShareWidget
                        referralPerks
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Referral CTA + Legal Footer)
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
                        .fill(Color(red: 0.07, green: 0.11, blue: 0.09).opacity(0.96))
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
                Image(systemName: "gift.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.primaryThemeColor)
                Text("PEER REFERRAL PASS")
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
    
    // MARK: - Referral Gift Card
    private var referralGiftCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.10, green: 0.18, blue: 0.14), Color(red: 0.06, green: 0.12, blue: 0.09)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(configuration.primaryThemeColor.opacity(0.4), lineWidth: 1.5)
                )
            
            VStack(spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(configuration.primaryThemeColor.opacity(0.2))
                            .frame(width: 44, height: 44)
                        Image(systemName: "person.2.badge.gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(configuration.primaryThemeColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("2-WAY REFERRAL VOUCHER")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(configuration.primaryThemeColor)
                        
                        Text("50% Discount Applied Instantly")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("SAVINGS ACTIVE")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(configuration.primaryThemeColor))
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                HStack(spacing: -8) {
                    Circle().fill(Color.orange).frame(width: 24, height: 24).overlay(Text("JD").font(.system(size: 9, weight: .bold)))
                    Circle().fill(Color.blue).frame(width: 24, height: 24).overlay(Text("SK").font(.system(size: 9, weight: .bold)))
                    Circle().fill(Color.purple).frame(width: 24, height: 24).overlay(Text("AL").font(.system(size: 9, weight: .bold)))
                    
                    Text("Alex, Mia and 4 others claimed recently")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.75))
                        .padding(.leading, 14)
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .frame(height: 125)
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
    
    // MARK: - Referral Code Share Widget
    private var referralCodeShareWidget: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("YOUR UNIQUE CODE")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
                Text(referralCode)
                    .font(.system(size: 15, weight: .heavy, design: .monospaced))
                    .foregroundColor(configuration.primaryThemeColor)
            }
            
            Spacer()
            
            Button {
                #if os(iOS)
                UIPasteboard.general.string = referralCode
                #elseif os(macOS)
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(referralCode, forType: .string)
                #endif
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isCodeCopied = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation { isCodeCopied = false }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isCodeCopied ? "checkmark" : "doc.on.doc.fill")
                        .font(.system(size: 11))
                    Text(isCodeCopied ? "Copied!" : "Copy Code")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(isCodeCopied ? .black : .white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(isCodeCopied ? configuration.primaryThemeColor : Color.white.opacity(0.12)))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06), lineWidth: 1))
        )
    }
    
    // MARK: - Referral Perks
    private var referralPerks: some View {
        VStack(spacing: 10) {
            perkRow(icon: "person.line.dotted.person.fill", title: "Share With Unlimited Friends", desc: "No invite limits. Every friend who subscribes adds an extra free month to your account.")
            perkRow(icon: "arrow.triangle.2.circlepath", title: "Mutual 50% Permanent Savings", desc: "Both your account and your invitees lock in half-price billing.")
            perkRow(icon: "star.fill", title: "Top Ambassador Leaderboard", desc: "Invite 5 friends to receive a free lifetime developer tier license.")
        }
    }
    
    private func perkRow(icon: String, title: String, desc: String) -> some View {
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
                                        textColor: .black
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
                    ProgressView().tint(.black)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Claim 50% Referral Discount")
                            .font(.system(size: 15, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundColor(.black)
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
    ReferAFriendUnlockDiscountPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
