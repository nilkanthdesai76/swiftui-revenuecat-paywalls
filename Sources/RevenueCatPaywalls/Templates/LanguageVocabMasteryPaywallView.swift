import SwiftUI
import RevenueCat

public struct LanguageVocabMasteryPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var isCardFlipped: Bool = false
    @State private var cardRotation: Double = 0
    @State private var speechScorePulse: CGFloat = 1.0
    
    let levels = [
        ("A1", "Beginner", true),
        ("A2", "Elementary", true),
        ("B1", "Intermediate", true),
        ("B2", "Conversational", true),
        ("C1", "Advanced Pro", false),
        ("C2", "Bilingual Master", false)
    ]
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Master Any Language Fast",
            appSubtitle: "Speak fluently in 90 days with AI accent coaching, native audio, and spaced repetition.",
            primaryThemeColor: Color(red: 0.98, green: 0.45, blue: 0.15),
            secondaryThemeColor: Color(red: 0.98, green: 0.75, blue: 0.15)
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
            Color(red: 0.08, green: 0.06, blue: 0.05)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Flashcard & Fluency Ladder
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        interactiveFlashcardSection
                        headlineSection
                        fluencyLadderSection
                        polyglotBenefits
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Speak CTA + Legal Footer)
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
                        .fill(Color(red: 0.11, green: 0.08, blue: 0.06).opacity(0.96))
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
                speechScorePulse = 1.08
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
                Image(systemName: "waveform.badge.mic")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("SUPER POLYGLOT UNLIMITED")
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
    
    // MARK: - Interactive Flashcard
    private var interactiveFlashcardSection: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                isCardFlipped.toggle()
                cardRotation += 180
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.18, green: 0.12, blue: 0.08), Color(red: 0.13, green: 0.09, blue: 0.06)],
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
                        Label(isCardFlipped ? "FRENCH (TARGET)" : "ENGLISH", systemImage: "globe.americas.fill")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(configuration.secondaryThemeColor)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "hand.tap.fill")
                            Text("Tap to flip")
                        }
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    if isCardFlipped {
                        VStack(spacing: 4) {
                            Text("L'heureux hasard")
                                .font(.system(size: 22, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                            Text("[lœ.ʁø a.zaʁ] • n.m.")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    } else {
                        VStack(spacing: 4) {
                            Text("Serendipity")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                            Text("[ˌsɛrənˈdɪpɪti] • noun")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 11))
                            Text("Native Audio 48kHz")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(configuration.primaryThemeColor)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 11))
                            Text("98% Native Accent")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(.green)
                        .scaleEffect(speechScorePulse)
                    }
                }
                .padding(16)
            }
            .frame(height: 160)
        }
        .buttonStyle(.plain)
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
    
    // MARK: - Fluency Ladder Section
    private var fluencyLadderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CEFR FLUENCY BENCHMARK")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.55))
                Spacer()
                Text("C2 NATIVE UNLOCKED")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(configuration.secondaryThemeColor)
            }
            
            HStack(spacing: 6) {
                ForEach(levels, id: \.0) { lvl in
                    VStack(spacing: 4) {
                        Text(lvl.0)
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(lvl.2 ? .black : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 28)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(lvl.2 ? configuration.secondaryThemeColor : Color.white.opacity(0.12))
                            )
                        
                        Text(lvl.1)
                            .font(.system(size: 7, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
        }
    }
    
    // MARK: - Polyglot Benefits
    private var polyglotBenefits: some View {
        VStack(spacing: 10) {
            polyglotRow(icon: "brain.head.profile", title: "Supermemo SRS Algorithm", desc: "Never forget a word. Daily reviews timed at the optimal memory forgetting curve.")
            polyglotRow(icon: "mic.badge.plus", title: "Real-Time AI Pronunciation Coach", desc: "Detects vowel tones and subtle intonations with instant acoustic feedback.")
            polyglotRow(icon: "book.closed.fill", title: "Unlimited 45+ Language Decks", desc: "Unlock full grammar, idioms, slang, and business conversational courses.")
            polyglotRow(icon: "airplane", title: "100% Offline Travel Mode", desc: "Download all audio dialogues and flashcards for overseas trips without internet.")
        }
    }
    
    private func polyglotRow(icon: String, title: String, desc: String) -> some View {
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
                        Image(systemName: "globe.europe.africa.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Start Fluent Speaking")
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
    LanguageVocabMasteryPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
