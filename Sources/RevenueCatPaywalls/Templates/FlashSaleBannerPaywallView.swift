import SwiftUI

public struct FlashSaleBannerPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var timeRemaining: Int = 14 * 60 + 59 // 15 mins
    @State private var claimPercentage: Double = 0.86
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Flash Sale Event",
            appSubtitle: "Limited-time flash discount unlocked for your account.",
            primaryThemeColor: Color(red: 0.95, green: 0.25, blue: 0.25),
            secondaryThemeColor: Color(red: 1.0, green: 0.65, blue: 0.0)
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
                // Header Bar with Close Button
                headerBar
                
                // Top Scrollable Flash Sale Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Ticker banner
                        MarqueeTickerView(
                            text: "⚡️ 24-HOUR FLASH SALE • SAVE 70% TODAY ⚡️",
                            backgroundColor: configuration.primaryThemeColor.opacity(0.12),
                            textColor: configuration.primaryThemeColor
                        )
                        
                        countdownClockSection
                        
                        claimProgressCard
                        
                        voucherCouponCard
                        
                        featuresChecklist
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + 1-Tap CTA + Legal Footer)
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
        .onAppear {
            startTimer()
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
                Image(systemName: "flame.fill")
                    .foregroundColor(configuration.primaryThemeColor)
                Text("SPECIAL EVENT")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(configuration.primaryThemeColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(configuration.primaryThemeColor.opacity(0.1), in: Capsule())
            
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
    
    // MARK: - Countdown Clock
    
    private var countdownClockSection: some View {
        VStack(spacing: 8) {
            Text("OFFER EXPIRES IN")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                timeBlock(value: String(format: "%02d", timeRemaining / 60), label: "MIN")
                Text(":")
                    .font(.system(size: 24, weight: .black, design: .monospaced))
                    .foregroundColor(configuration.primaryThemeColor)
                timeBlock(value: String(format: "%02d", timeRemaining % 60), label: "SEC")
            }
        }
        .padding(.vertical, 4)
    }
    
    private func timeBlock(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 26, weight: .black, design: .monospaced))
                .foregroundColor(.primary)
                .frame(width: 58, height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.appSecondarySystemBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(configuration.primaryThemeColor.opacity(0.3), lineWidth: 1.5)
                        )
                )
            
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - Claim Progress
    
    private var claimProgressCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🔥 86% of promotional spots claimed")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                Text("Only 14 left")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(configuration.primaryThemeColor)
            }
            
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [configuration.secondaryThemeColor, configuration.primaryThemeColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: proxy.size.width * claimPercentage, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.appSecondarySystemBackground)
        )
    }
    
    // MARK: - Voucher Coupon Card
    
    private var voucherCouponCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("COUPON: FLASHSALE70")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundColor(.primary)
                
                Text("Instant 70% discount applied to your checkout")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("APPLIED")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green, in: Capsule())
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.appSecondarySystemBackground.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                        .foregroundColor(configuration.primaryThemeColor.opacity(0.4))
                )
        )
    }
    
    // MARK: - Checklist
    
    private var featuresChecklist: some View {
        VStack(spacing: 8) {
            checkItem("Lock in discounted rate forever (price never increases)")
            checkItem("Immediate access to all current and upcoming Pro features")
            checkItem("Cancel anytime in App Store Subscriptions with zero fees")
        }
    }
    
    private func checkItem(_ title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(configuration.primaryThemeColor)
                .font(.system(size: 14))
            
            Text(title)
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
                                    Text(badge)
                                        .font(.system(size: 9, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(configuration.primaryThemeColor, in: Capsule())
                                        .lineLimit(1)
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
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.4), radius: 12, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text("Claim Flash Discount")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "bolt.fill")
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

#Preview("Flash Sale Banner Paywall") {
    FlashSaleBannerPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
