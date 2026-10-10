import SwiftUI
import RevenueCat

public struct RetroArcadeGamingPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var coinBlink: Bool = false
    @State private var scanlineOffset: CGFloat = -80
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Retro Arcade Pro Pass",
            appSubtitle: "Unlock unlimited save states, 60 FPS rewind, cheat codes, and Bluetooth gamepad rumble.",
            primaryThemeColor: Color(red: 0.95, green: 0.20, blue: 0.50),
            secondaryThemeColor: Color(red: 0.20, green: 0.85, blue: 0.95)
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
            Color(red: 0.05, green: 0.04, blue: 0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Arcade Screen & Game Perks
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        arcadeCabinetScreen
                        headlineSection
                        pixelHeartStatus
                        arcadeFeatures
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Press Start CTA + Legal Footer)
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
                        .fill(Color(red: 0.08, green: 0.06, blue: 0.12).opacity(0.96))
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
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                coinBlink.toggle()
            }
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                scanlineOffset = 80
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
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("CREDIT: 99 • UNLIMITED")
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
    
    // MARK: - Arcade Cabinet Screen
    private var arcadeCabinetScreen: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.10, green: 0.08, blue: 0.16))
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
            
            VStack(spacing: 12) {
                HStack {
                    Text("1UP 999900")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(configuration.secondaryThemeColor)
                    Spacer()
                    Text("HI-SCORE 999990")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(configuration.primaryThemeColor)
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text("GAME OVER?")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text("INSERT COIN TO CONTINUE")
                        .font(.system(size: 13, weight: .heavy, design: .monospaced))
                        .foregroundColor(coinBlink ? configuration.secondaryThemeColor : .white.opacity(0.2))
                }
                
                Spacer()
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "cpu")
                            .font(.system(size: 11))
                        Text("60 FPS SMOOTH")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.green)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "opticaldiscdrive.fill")
                            .font(.system(size: 11))
                        Text("BIOS INCLUDED")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(configuration.primaryThemeColor)
                }
            }
            .padding(16)
            
            // Subtle CRT Scanline effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.08), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 12)
                .offset(y: scanlineOffset)
        }
        .frame(height: 155)
        .clipped()
    }
    
    // MARK: - Headline
    private var headlineSection: some View {
        VStack(spacing: 8) {
            Text(configuration.appTitle)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    // MARK: - Pixel Hearts HP
    private var pixelHeartStatus: some View {
        HStack {
            Text("LIVES REMAINING:")
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "heart.fill").foregroundColor(.red)
                Image(systemName: "heart.fill").foregroundColor(.red)
                Image(systemName: "heart.fill").foregroundColor(.red)
                Image(systemName: "infinity").foregroundColor(configuration.secondaryThemeColor).font(.system(size: 12, weight: .bold))
            }
            .font(.system(size: 12))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.06), lineWidth: 1))
        )
    }
    
    // MARK: - Arcade Features
    private var arcadeFeatures: some View {
        VStack(spacing: 10) {
            arcadeRow(icon: "backward.end.alt.fill", title: "Instant Rewind (60s Replay)", desc: "Missed a jump or lost a boss fight? Tap rewind to turn back time instantly.")
            arcadeRow(icon: "opticaldisc.fill", title: "Unlimited Cloud Save States", desc: "Never lose game progress. Save anywhere, sync across iPad, iPhone, and Mac.")
            arcadeRow(icon: "gamecontroller.fill", title: "DualSense & Xbox Rumble Feedback", desc: "Native haptic vibration and low-latency Bluetooth gamepad mapping.")
            arcadeRow(icon: "bolt.badge.clock.fill", title: "Fast-Forward 4x Turbo Mode", desc: "Skip slow unskippable intros, turn-based dialogue, and grind screens.")
        }
    }
    
    private func arcadeRow(icon: String, title: String, desc: String) -> some View {
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
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Press Start • Unlock All")
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
    RetroArcadeGamingPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
