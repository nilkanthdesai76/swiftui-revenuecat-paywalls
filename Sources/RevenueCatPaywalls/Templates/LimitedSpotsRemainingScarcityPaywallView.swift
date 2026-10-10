import SwiftUI
import RevenueCat

public struct LimitedSpotsRemainingScarcityPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var minutes: Int = 9
    @State private var seconds: Int = 48
    @State private var greenPulse: CGFloat = 1.0
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Special Rate Reserved",
            appSubtitle: "We have temporarily reserved a 50% discount spot for your account.",
            primaryThemeColor: Color(red: 0.20, green: 0.85, blue: 0.45),
            secondaryThemeColor: Color(red: 0.98, green: 0.65, blue: 0.15)
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
            Color(red: 0.05, green: 0.08, blue: 0.06)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Scarcity Reservation & Timer
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        reservationStatusCard
                        headlineSection
                        reservationTimerRow
                        reservationPerks
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Reserve CTA + Legal Footer)
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
                        .fill(Color(red: 0.07, green: 0.11, blue: 0.08).opacity(0.96))
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
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                greenPulse = 1.3
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if seconds > 0 {
                    seconds -= 1
                } else if minutes > 0 {
                    minutes -= 1
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
                Circle()
                    .fill(configuration.primaryThemeColor)
                    .frame(width: 8, height: 8)
                    .scaleEffect(greenPulse)
                Text("2 SPOTS HELD IN REGION")
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
    
    // MARK: - Reservation Status Card
    private var reservationStatusCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.10, green: 0.18, blue: 0.12), Color(red: 0.06, green: 0.12, blue: 0.08)],
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
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 22))
                            .foregroundColor(configuration.primaryThemeColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ACTIVE RESERVATION HOLD")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(configuration.primaryThemeColor)
                        
                        Text("Account Slot #92 Locked In")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("50% SAVED")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(configuration.primaryThemeColor))
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                Text("If you dismiss this screen, this reserved capacity spot automatically releases to the next queue participant.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
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
    
    // MARK: - Reservation Timer Row
    private var reservationTimerRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(configuration.secondaryThemeColor)
            
            Text("Hold expires in:")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Text(String(format: "%02d:%02d", minutes, seconds))
                .font(.system(size: 15, weight: .black, design: .monospaced))
                .foregroundColor(configuration.secondaryThemeColor)
            
            Spacer()
            
            Text("Guaranteed Rate")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06), lineWidth: 1))
        )
    }
    
    // MARK: - Reservation Perks
    private var reservationPerks: some View {
        VStack(spacing: 10) {
            reservationRow(icon: "checkmark.seal.fill", title: "Rate Guaranteed on Renewal", desc: "Lock in half-price billing for the lifetime of your continuous active subscription.")
            reservationRow(icon: "sparkles", title: "Instant Pro Feature Access", desc: "No delay. Every single pro feature and advanced setting unlocks immediately upon checkout.")
            reservationRow(icon: "shield.fill", title: "Apple Secure Checkout", desc: "Protected by Apple In-App Purchase encryption and one-tap cancellation anytime in Settings.")
        }
    }
    
    private func reservationRow(icon: String, title: String, desc: String) -> some View {
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
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Lock In My Reserved Rate")
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
    LimitedSpotsRemainingScarcityPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
