import SwiftUI
import RevenueCat

public struct SeasonalSpringBlackFridayDarkNeonPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var hours: Int = 4
    @State private var minutes: Int = 22
    @State private var seconds: Int = 18
    @State private var neonGlow: CGFloat = 1.0
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Black Friday Mega Sale",
            appSubtitle: "Biggest discount of the year. Save 70% on all Pro plans before midnight.",
            primaryThemeColor: Color(red: 1.0, green: 0.15, blue: 0.60),
            secondaryThemeColor: Color(red: 0.15, green: 0.95, blue: 0.85)
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
            Color(red: 0.04, green: 0.02, blue: 0.07)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Neon Banner & Timer
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        neonDiscountBanner
                        headlineSection
                        countdownClockRow
                        seasonalPerks
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Neon CTA + Legal Footer)
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
                        .fill(Color(red: 0.07, green: 0.03, blue: 0.10).opacity(0.96))
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
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                neonGlow = 1.15
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if seconds > 0 {
                    seconds -= 1
                } else if minutes > 0 {
                    minutes -= 1
                    seconds = 59
                } else if hours > 0 {
                    hours -= 1
                    minutes = 59
                    seconds = 59
                }
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
                Image(systemName: "bolt.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("FLASH DEAL • 70% OFF")
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
    
    // MARK: - Neon Discount Banner
    private var neonDiscountBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.12, green: 0.05, blue: 0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: configuration.primaryThemeColor.opacity(0.4), radius: 10)
            
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 14))
                        .foregroundColor(configuration.secondaryThemeColor)
                    Text("ANNUAL MEGA SALE EXCLUSIVE")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundColor(configuration.secondaryThemeColor)
                }
                
                Text("SAVE 70% TODAY")
                    .font(.system(size: 26, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .scaleEffect(neonGlow)
                
                Text("Original $89.99/yr slashed down to $26.99/yr")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.75))
            }
            .padding(16)
        }
        .frame(height: 120)
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
    
    // MARK: - Countdown Clock Row
    private var countdownClockRow: some View {
        HStack(spacing: 12) {
            timeBox(title: "HOURS", val: String(format: "%02d", hours))
            Text(":").font(.system(size: 18, weight: .black)).foregroundColor(.white.opacity(0.6))
            timeBox(title: "MINS", val: String(format: "%02d", minutes))
            Text(":").font(.system(size: 18, weight: .black)).foregroundColor(.white.opacity(0.6))
            timeBox(title: "SECS", val: String(format: "%02d", seconds))
        }
        .padding(.vertical, 8)
    }
    
    private func timeBox(title: String, val: String) -> some View {
        VStack(spacing: 2) {
            Text(val)
                .font(.system(size: 22, weight: .black, design: .monospaced))
                .foregroundColor(configuration.secondaryThemeColor)
            Text(title)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(width: 65, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08), lineWidth: 1))
        )
    }
    
    // MARK: - Seasonal Perks
    private var seasonalPerks: some View {
        VStack(spacing: 10) {
            seasonalRow(icon: "sparkles.square.fill.on.square.fill", title: "Free 2026 Pro Preset Bundle ($49 Value)", desc: "Included at zero extra cost with your Black Friday discount subscription.")
            seasonalRow(icon: "lock.open.trianglebadge.exclamationmark.fill", title: "Permanent Price Lock Guarantee", desc: "Your subscription renews at this 70% discounted rate forever.")
            seasonalRow(icon: "arrow.uturn.backward.circle.fill", title: "100% Risk-Free 30-Day Refund", desc: "Not satisfied? Get a full no-questions-asked refund via Apple App Store.")
        }
    }
    
    private func seasonalRow(icon: String, title: String, desc: String) -> some View {
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
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Claim 70% Holiday Deal")
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
    SeasonalSpringBlackFridayDarkNeonPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
