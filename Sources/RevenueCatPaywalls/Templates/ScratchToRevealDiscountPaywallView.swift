import SwiftUI

public struct ScratchToRevealDiscountPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var isRevealed: Bool = false
    @State private var showConfetti: Bool = false
    @State private var timeRemaining: Int = 14 * 60 + 59
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Mystery Discount Unlocked",
            appSubtitle: "Tap to reveal your personalized VIP promotional voucher.",
            primaryThemeColor: Color(red: 0.95, green: 0.70, blue: 0.15),
            secondaryThemeColor: Color(red: 0.95, green: 0.35, blue: 0.25)
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
                
                // Top Scrollable Interactive Canvas
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headlineSection
                        
                        // Interactive Mystery Voucher Card
                        mysteryVoucherCard
                        
                        if isRevealed {
                            reservationTimerCard
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }
                        
                        mysteryPerksList
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
            
            // Confetti Burst Overlay
            ConfettiParticleView(isEmitting: showConfetti)
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
                Image(systemName: "gift.fill")
                    .foregroundColor(configuration.primaryThemeColor)
                Text("EXCLUSIVE PERK")
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
    
    // MARK: - Mystery Voucher Card
    
    private var mysteryVoucherCard: some View {
        VStack(spacing: 12) {
            if !isRevealed {
                // Scratch / Tap Prompt State
                Button(action: revealDiscount) {
                    VStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(configuration.primaryThemeColor)
                            .shimmering(duration: 1.5)
                        
                        Text("TAP TO SCRATCH & REVEAL")
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("You've been randomly selected for a surprise VIP discount")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.appSecondarySystemBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                    .foregroundColor(configuration.primaryThemeColor.opacity(0.6))
                            )
                    )
                }
                .buttonStyle(.plain)
            } else {
                // Revealed Voucher State
                VStack(spacing: 8) {
                    HStack {
                        Text("GOLDEN VIP VOUCHER")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .foregroundColor(configuration.primaryThemeColor)
                        
                        Spacer()
                        
                        Text("60% OFF")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(configuration.secondaryThemeColor, in: Capsule())
                    }
                    
                    Text("SECRET DISCOUNT UNLOCKED!")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Your exclusive promo voucher is automatically applied below.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(18)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(configuration.primaryThemeColor.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(configuration.primaryThemeColor, lineWidth: 1.5)
                        )
                )
            }
        }
    }
    
    private func revealDiscount() {
        HapticFeedback.success()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isRevealed = true
            showConfetti = true
        }
        startTimer()
    }
    
    // MARK: - Reservation Timer Card
    
    private var reservationTimerCard: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .foregroundColor(configuration.secondaryThemeColor)
                .font(.system(size: 13, weight: .bold))
            
            Text("Voucher reserved for: \(formattedTime)")
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundColor(configuration.secondaryThemeColor)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(configuration.secondaryThemeColor.opacity(0.12), in: Capsule())
    }
    
    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
    
    // MARK: - Perks
    
    private var mysteryPerksList: some View {
        VStack(spacing: 8) {
            perkLine("App Store verified zero-risk guarantee")
            perkLine("Includes instant synchronization & priority speed")
            perkLine("Switch or cancel anytime in iPhone Settings")
        }
    }
    
    private func perkLine(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(configuration.primaryThemeColor)
                .font(.system(size: 13))
            
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
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.12) : Color.appSystemBackground)
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
                        Text(isRevealed ? "Claim Mystery Discount" : "Unlock Mystery Voucher")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "gift.fill")
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

#Preview("Scratch To Reveal Discount Paywall") {
    ScratchToRevealDiscountPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
