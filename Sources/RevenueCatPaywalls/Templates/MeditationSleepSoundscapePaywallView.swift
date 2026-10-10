import SwiftUI
import RevenueCat

public struct MeditationSleepSoundscapePaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var breatheScale: CGFloat = 0.85
    @State private var breatheText: String = "Breathe In..."
    @State private var starTwinkle: Double = 0.3
    @State private var selectedSound: String = "Rain on Leaves"
    
    let ambientSounds = [
        ("cloud.rain.fill", "Rain on Leaves"),
        ("waveform.path", "432Hz Binaural"),
        ("flame.fill", "Campfire Embers"),
        ("water.waves", "Ocean Tides")
    ]
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Serenity & Deep Sleep",
            appSubtitle: "Fall asleep in minutes with 500+ hypnotic stories, soothing soundscapes, and breathwork.",
            primaryThemeColor: Color(red: 0.62, green: 0.52, blue: 0.98),
            secondaryThemeColor: Color(red: 0.35, green: 0.75, blue: 0.98)
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
            // Twilight Night Sky Gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.12),
                    Color(red: 0.08, green: 0.06, blue: 0.18),
                    Color(red: 0.03, green: 0.03, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Breathing & Sleep Sanctuary
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        breathingCircleVisual
                        headlineSection
                        soundscapeMixerSection
                        serenityBenefits
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Calm CTA + Legal Footer)
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
                        .fill(Color(red: 0.07, green: 0.06, blue: 0.14).opacity(0.96))
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
            startBreathingAnimation()
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                starTwinkle = 0.9
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
    
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            breatheScale = 1.2
        }
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            breatheText = (breatheText == "Breathe In...") ? "Breathe Out..." : "Breathe In..."
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
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.primaryThemeColor)
                Text("ALL-ACCESS SLEEP PASS")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
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
    
    // MARK: - Breathing Circle Visual
    private var breathingCircleVisual: some View {
        ZStack {
            // Ambient Starry Glow
            Circle()
                .fill(configuration.primaryThemeColor.opacity(0.15))
                .frame(width: 160, height: 160)
                .blur(radius: 25)
            
            // Outer Pulsing Aura
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [configuration.primaryThemeColor.opacity(0.4), configuration.secondaryThemeColor.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 140, height: 140)
                .scaleEffect(breatheScale)
            
            // Inner Core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            configuration.primaryThemeColor.opacity(0.4),
                            Color(red: 0.12, green: 0.08, blue: 0.25).opacity(0.8)
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 60
                    )
                )
                .frame(width: 110, height: 110)
                .scaleEffect(breatheScale * 0.95)
            
            VStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(configuration.secondaryThemeColor)
                    .opacity(starTwinkle)
                Text(breatheText)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(height: 155)
    }
    
    // MARK: - Headline
    private var headlineSection: some View {
        VStack(spacing: 8) {
            Text(configuration.appTitle)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    // MARK: - Soundscape Mixer Chips
    private var soundscapeMixerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("INTERACTIVE SOUND MIXER")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.55))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(ambientSounds, id: \.1) { sound in
                    let isCurrent = selectedSound == sound.1
                    
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            selectedSound = sound.1
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: sound.0)
                                .font(.system(size: 13))
                                .foregroundColor(isCurrent ? configuration.secondaryThemeColor : .white.opacity(0.6))
                            Text(sound.1)
                                .font(.system(size: 11, weight: isCurrent ? .bold : .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isCurrent ? configuration.primaryThemeColor.opacity(0.25) : Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(isCurrent ? configuration.primaryThemeColor.opacity(0.6) : Color.white.opacity(0.08), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Serenity Benefits
    private var serenityBenefits: some View {
        VStack(spacing: 10) {
            serenityRow(icon: "bed.double.fill", title: "500+ Hypnotic Sleep Stories", desc: "Voiced by world-renowned narrators to drift into rapid REM sleep.")
            serenityRow(icon: "waveform.badge.magnifyingglass", title: "Binaural & Solfeggio Frequencies", desc: "Scientifically calibrated delta waves to decrease night-time anxiety.")
            serenityRow(icon: "arrow.down.circle.fill", title: "Offline Bedtime Mode", desc: "Download favorite tracks for phone-free airplane and cabin retreats.")
            serenityRow(icon: "heart.text.square.fill", title: "Apple Health Mindfulness Sync", desc: "Automatically track your mindful minutes and resting heart rate.")
        }
    }
    
    private func serenityRow(icon: String, title: String, desc: String) -> some View {
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
                        Image(systemName: "sparkles")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Begin Peaceful Journey")
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
    MeditationSleepSoundscapePaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
