import SwiftUI

public struct SpecialOfferDownsellPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var specialPackage: PaywallPackage?
    public var discountHeadline: String
    public var countdownMinutes: Int
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var timeRemaining: Int
    @State private var pulseScale: CGFloat = 1.0
    @State private var badgeShimmer: Bool = false
    @State private var timerActive: Bool = true
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Wait! Exclusive Exit Offer",
            appSubtitle: "Before you leave, grab our best lifetime discount. This deal won't appear again.",
            appIconSystemName: "tag.fill",
            primaryThemeColor: Color(red: 0.95, green: 0.25, blue: 0.35),
            secondaryThemeColor: Color(red: 0.98, green: 0.55, blue: 0.22)
        ),
        specialPackage: PaywallPackage? = nil,
        discountHeadline: String = "SAVE 75% FOREVER",
        countdownMinutes: Int = 10,
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.specialPackage = specialPackage
        self.discountHeadline = discountHeadline
        self.countdownMinutes = countdownMinutes
        self._timeRemaining = State(initialValue: countdownMinutes * 60)
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    private var targetPackage: PaywallPackage {
        specialPackage
            ?? manager.packages.first(where: { $0.kind == .lifetime })
            ?? manager.packages.first(where: { $0.kind == .annual })
            ?? MockData.sampleLifetime
    }
    
    public var body: some View {
        ZStack {
            // High-energy dark background with radial spotlight
            ambientBackground
            
            VStack(spacing: 0) {
                // Top close bar (subtle close)
                HStack {
                    Spacer()
                    Button(action: {
                        HapticFeedback.light()
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                
                // Top Scrollable Section
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Flashing Countdown Banner
                        countdownBadge
                            .padding(.top, 4)
                        
                        // Hero Icon & Title
                        heroHeadlineSection
                        
                        // Featured Single Offer Card
                        specialDealCard
                        
                        // Trust & Value Bullets
                        valueBulletsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                
                // Static Sticky Bottom Dock (Never scrolls)
                VStack(spacing: 12) {
                    claimButton
                    
                    // Subtle decline button
                    Button(action: {
                        HapticFeedback.light()
                        onDismiss()
                    }) {
                        Text("No thanks, I'll pay regular price later")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .padding(.bottom, 2)
                    
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 16)
                .background(
                    Rectangle()
                        .fill(Color(red: 0.08, green: 0.08, blue: 0.11))
                        .overlay(
                            Rectangle()
                                .fill(LinearGradient(
                                    colors: [Color.white.opacity(0.08), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startTimer()
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
            }
        }
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Ambient Background
    
    private var ambientBackground: some View {
        ZStack {
            Color(red: 0.06, green: 0.06, blue: 0.09).ignoresSafeArea()
            
            // Spotlight Glow
            Circle()
                .fill(configuration.primaryThemeColor.opacity(0.35))
                .frame(width: 340, height: 340)
                .blur(radius: 95)
                .offset(y: -120)
            
            Circle()
                .fill(configuration.secondaryThemeColor.opacity(0.2))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(y: 160)
        }
    }
    
    // MARK: - Countdown Badge
    
    private var countdownBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(configuration.secondaryThemeColor)
            
            Text("SPECIAL OFFER EXPIRES IN:")
                .font(.system(size: 11, weight: .black, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
            
            Text(formattedCountdown)
                .font(.system(size: 14, weight: .black, design: .monospaced))
                .foregroundColor(configuration.secondaryThemeColor)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
                .overlay(
                    Capsule()
                        .stroke(configuration.secondaryThemeColor.opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    private var formattedCountdown: String {
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
    
    // MARK: - Headline
    
    private var heroHeadlineSection: some View {
        VStack(spacing: 8) {
            Text(configuration.appTitle)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 14)
        }
    }
    
    // MARK: - Single Special Deal Card
    
    private var specialDealCard: some View {
        let pkg = targetPackage
        
        return VStack(spacing: 12) {
            HStack {
                Text(discountHeadline)
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(configuration.primaryThemeColor, in: Capsule())
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .shimmering(duration: 1.8)
                
                Spacer()
                
                Text("ONE-TIME PAYMENT")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(configuration.secondaryThemeColor)
                    .lineLimit(1)
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(pkg.title)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                    
                    Text("Unlock forever • All future updates included")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.65))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    Text("$199.99")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .strikethrough(true, color: .red)
                        .foregroundColor(.white.opacity(0.4))
                        .lineLimit(1)
                    
                    Text(pkg.localizedPriceString)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(configuration.secondaryThemeColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: configuration.primaryThemeColor.opacity(0.3), radius: 16, y: 6)
        )
    }
    
    // MARK: - Value Bullets
    
    private var valueBulletsSection: some View {
        VStack(spacing: 10) {
            bulletRow(icon: "checkmark.seal.fill", text: "Pay once, never pay monthly fees again")
            bulletRow(icon: "infinity", text: "Guaranteed access to all v2.0+ major updates")
            bulletRow(icon: "sparkles", text: "Priority access to new AI & pro power features")
            bulletRow(icon: "shield.checkered", text: "30-day money back guarantee by Apple")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.03))
        )
    }
    
    private func bulletRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(configuration.secondaryThemeColor)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
            
            Spacer()
        }
    }
    
    // MARK: - Claim Button (Sticky Dock)
    
    private var claimButton: some View {
        Button(action: {
            HapticFeedback.heavy()
            Task {
                if await manager.purchase(package: targetPackage) {
                    onPurchaseSuccess?()
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.55), radius: 14, y: 5)
                    .scaleEffect(pulseScale)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        
                        Text("Claim 75% Discount Now")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 56)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Special Offer Downsell Paywall") {
    SpecialOfferDownsellPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
