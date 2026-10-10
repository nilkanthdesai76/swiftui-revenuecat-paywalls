import SwiftUI
import RevenueCatPaywalls

public enum PaywallCategory: String, CaseIterable, Identifiable {
    case all = "All (40)"
    case general = "General Archetypes (23)"
    case discounts = "Discount Offers (17)"
    
    public var id: String { rawValue }
}

public enum PaywallTemplateType: String, CaseIterable, Identifiable {
    // General Archetypes (23)
    case bento = "Glassmorphic Bento"
    case timeline = "Apple Timeline Trial"
    case habitStreak = "Habit Streak & Social Proof"
    case comparisonMatrix = "Feature Comparison Matrix"
    case mediaWaveform = "Media Waveform & Pulse"
    case cyberpunk = "Cyberpunk Neo-Brutalist"
    case compactSheet = "Compact Sheet Modal"
    case minimalistEditorial = "Minimalist Editorial"
    case spatialImmersive = "Spatial Immersive"
    case beforeAfterSlider = "Before/After Drag Slider"
    case videoHeroCinematic = "Video Hero Cinematic"
    case fitnessRingsMetrics = "Fitness Rings Metrics"
    case quizResultsPersonalized = "Quiz Results Personalized"
    case financeWealthClean = "Finance Wealth Clean"
    case socialProofWall = "Social Proof Wall"
    case aiPromptTokensMeter = "AI Prompt Quota & Models"
    case documentScannerPDF = "Scanner & PDF OCR Studio"
    case vpnSecurityShield = "VPN & Privacy UltraShield"
    case meditationSleepSoundscape = "Meditation & Sleep Soundscape"
    case languageVocabMastery = "Language & Polyglot Mastery"
    case travelFlightTracker = "Flight Radar & Travel Pass"
    case retroArcadeGaming = "Retro Arcade Game Pass"
    case podcastAudiobookPlayer = "Master Audio & Podcast Suite"
    
    // Discount & Exit-Intent Offer Designs (17)
    case specialOffer = "Exit-Offer Special Downsell"
    case flashSale = "24H Flash Sale Event"
    case twoTierUpgrade = "Lifetime VIP Value Anchor"
    case scratchToReveal = "Scratch & Reveal Mystery Deal"
    case winBackRetention = "Empathetic Win-Back Offer"
    case spinToWinWheel = "Spin to Win Lucky Wheel"
    case holidaySeasonalGift = "Holiday Seasonal Gift Box"
    case studentCreatorGrant = "Student & Creator Grant"
    case abandonedCartNotification = "Abandoned Cart iOS Alert"
    case annualVsMonthlyFrictionKiller = "Low-Friction Trial Extension"
    case earlyBirdLaunch = "Early Bird Launch (#500 Spots)"
    case founderPersonalLetter = "Founder's Personal Letter (50%)"
    case payWhatYouWantSliding = "Pay-What-You-Want Scale"
    case referAFriendUnlock = "Refer a Friend 50/50 Pass"
    case seasonalNeonFlash = "Neon Flash Cyber Sale (70%)"
    case limitedSpotsRemaining = "Timezone Hold Reservation (2 Left)"
    case familySharingSplit = "iCloud Family Sharing Split ($0.83/mo)"
    
    public var id: String { rawValue }
    
    public var category: PaywallCategory {
        switch self {
        case .bento, .timeline, .habitStreak, .comparisonMatrix, .mediaWaveform, .cyberpunk, .compactSheet,
             .minimalistEditorial, .spatialImmersive, .beforeAfterSlider, .videoHeroCinematic, .fitnessRingsMetrics,
             .quizResultsPersonalized, .financeWealthClean, .socialProofWall, .aiPromptTokensMeter, .documentScannerPDF,
             .vpnSecurityShield, .meditationSleepSoundscape, .languageVocabMastery, .travelFlightTracker,
             .retroArcadeGaming, .podcastAudiobookPlayer:
            return .general
        case .specialOffer, .flashSale, .twoTierUpgrade, .scratchToReveal, .winBackRetention,
             .spinToWinWheel, .holidaySeasonalGift, .studentCreatorGrant, .abandonedCartNotification,
             .annualVsMonthlyFrictionKiller, .earlyBirdLaunch, .founderPersonalLetter, .payWhatYouWantSliding,
             .referAFriendUnlock, .seasonalNeonFlash, .limitedSpotsRemaining, .familySharingSplit:
            return .discounts
        }
    }
    
    public var subtitle: String {
        switch self {
        case .bento: return "Spatial blur tiles & interactive micro-widgets with pinned dock"
        case .timeline: return "3-step visual trial timeline + interactive toggle (App Store #1 layout)"
        case .habitStreak: return "Gamified streak flame rings & milestone roadmap with static plans"
        case .comparisonMatrix: return "Side-by-side Free vs Pro table with checkmark highlights & sticky CTA"
        case .mediaWaveform: return "Tap-reactive audio equalizer visualizer & studio master tracks"
        case .cyberpunk: return "Laser scanner line & terminal text cursor for dev/crypto tools"
        case .compactSheet: return "Biometric padlock unlock animation with fast 1-tap checkout"
        case .minimalistEditorial: return "Luxury editorial serif typography, magazine quotes & clean checklist"
        case .spatialImmersive: return "visionOS ambient aurora gradients, 3D depth & holographic tiles"
        case .beforeAfterSlider: return "Interactive draggable split-screen visualizer comparing Free vs Pro"
        case .videoHeroCinematic: return "Hollywood 4K ProRes dark aesthetic with tech specs & studio master reel"
        case .fitnessRingsMetrics: return "Apple Watch concentric activity rings & personalized daily calorie targets"
        case .quizResultsPersonalized: return "Onboarding quiz trajectory roadmap with 94% algorithm success score"
        case .financeWealthClean: return "Bloomberg & Copilot wealth growth simulator with AES-256 bank encryption"
        case .socialProofWall: return "4.9-star ratings banner & verified App Store subscriber testimonials"
        case .aiPromptTokensMeter: return "Live quota gauge, LLM model grid (GPT-4o, Claude 3.5), and speed benchmark"
        case .documentScannerPDF: return "Moving cyan laser beam scanner, real-time OCR text highlight, and PDF vault"
        case .vpnSecurityShield: return "3D cybersecurity shield with animated ping radar & 90+ global server nodes"
        case .meditationSleepSoundscape: return "Twilight night sky with animated breathing circle & interactive sound mixer"
        case .languageVocabMastery: return "3D vocabulary flashcard flip, CEFR fluency ladder (A1-C2), and AI accent coach"
        case .travelFlightTracker: return "Perforated boarding pass (JFK-LHR), flight progress bar, and altitude telemetry"
        case .retroArcadeGaming: return "8-bit CRT arcade scanlines, blinking INSERT COIN credit, and 60 FPS rewind"
        case .podcastAudiobookPlayer: return "Rotating vinyl record player, word-by-word AI transcripts, and silence trimmer"
            
        case .specialOffer: return "Exit-intent 1-offering deal with live ticking timer & 75% OFF badge"
        case .flashSale: return "Urgency marquee ticker, claim meter & instant voucher coupon code"
        case .twoTierUpgrade: return "Value math breakdown comparing recurring annual vs lifetime pass"
        case .scratchToReveal: return "Gamified scratch-off mystery voucher with celebratory confetti particles"
        case .winBackRetention: return "Empathetic indie developer 50% community grant for price-sensitive users"
        case .spinToWinWheel: return "Interactive spinning fortune wheel landing on 70% off with haptic bursts"
        case .holidaySeasonalGift: return "Holiday seasonal gift unboxing with festive red & pine green ribbon bounce"
        case .studentCreatorGrant: return "60% academic & creator aid grant with verified educational badge"
        case .abandonedCartNotification: return "Simulated iOS lockscreen push alert from founder with $20 credit voucher"
        case .annualVsMonthlyFrictionKiller: return "Risk-reversal low installment terms with zero upfront friction"
        case .earlyBirdLaunch: return "Founding member certificate #384 of 500 with lifetime grandfathered rate"
        case .founderPersonalLetter: return "Heartfelt personal note & signature from solo indie creator with 50% discount"
        case .payWhatYouWantSliding: return "Customizable contribution slider ($19 - $99) supporting open-source software"
        case .referAFriendUnlock: return "Viral 2-way referral coupon with copyable code FRIEND50-VIP and friend avatars"
        case .seasonalNeonFlash: return "High-octane cyberpunk neon mega flash sale with live countdown clock"
        case .limitedSpotsRemaining: return "Geo-targeted capacity hold timer reserving slot #92 with lock-in guarantee"
        case .familySharingSplit: return "Interactive family stepper calculating split price down to $0.83 / mo / member"
        }
    }
    
    public var icon: String {
        switch self {
        case .bento: return "square.grid.2x2.fill"
        case .timeline: return "timeline.selection"
        case .habitStreak: return "flame.fill"
        case .comparisonMatrix: return "tablecells.badge.ellipsis"
        case .mediaWaveform: return "waveform"
        case .cyberpunk: return "terminal.fill"
        case .compactSheet: return "lock.shield.fill"
        case .minimalistEditorial: return "text.book.closed.fill"
        case .spatialImmersive: return "visionpro"
        case .beforeAfterSlider: return "slider.horizontal.below.rectangle"
        case .videoHeroCinematic: return "film.fill"
        case .fitnessRingsMetrics: return "figure.run"
        case .quizResultsPersonalized: return "chart.xyaxis.line"
        case .financeWealthClean: return "chart.line.uptrend.xyaxis"
        case .socialProofWall: return "star.bubble.fill"
        case .aiPromptTokensMeter: return "sparkles"
        case .documentScannerPDF: return "doc.viewfinder"
        case .vpnSecurityShield: return "shield.lefthalf.filled.badge.checkmark"
        case .meditationSleepSoundscape: return "moon.stars.fill"
        case .languageVocabMastery: return "globe.americas.fill"
        case .travelFlightTracker: return "airplane.circle.fill"
        case .retroArcadeGaming: return "gamecontroller.fill"
        case .podcastAudiobookPlayer: return "headphones"
            
        case .specialOffer: return "tag.fill"
        case .flashSale: return "bolt.fill"
        case .twoTierUpgrade: return "crown.fill"
        case .scratchToReveal: return "gift.fill"
        case .winBackRetention: return "heart.fill"
        case .spinToWinWheel: return "arrow.triangle.2.circlepath"
        case .holidaySeasonalGift: return "gift.circle.fill"
        case .studentCreatorGrant: return "graduationcap.fill"
        case .abandonedCartNotification: return "bell.badge.fill"
        case .annualVsMonthlyFrictionKiller: return "checkmark.shield.fill"
        case .earlyBirdLaunch: return "seal.fill"
        case .founderPersonalLetter: return "envelope.open.fill"
        case .payWhatYouWantSliding: return "slider.horizontal.3"
        case .referAFriendUnlock: return "person.2.badge.gearshape.fill"
        case .seasonalNeonFlash: return "bolt.badge.clock.fill"
        case .limitedSpotsRemaining: return "lock.shield.fill"
        case .familySharingSplit: return "person.3.sequence.fill"
        }
    }
    
    public var accentColor: Color {
        switch self {
        case .bento: return Color(red: 0.38, green: 0.35, blue: 0.98)
        case .timeline: return Color(red: 0.16, green: 0.50, blue: 0.98)
        case .habitStreak: return Color(red: 0.94, green: 0.35, blue: 0.20)
        case .comparisonMatrix: return Color(red: 0.12, green: 0.58, blue: 0.95)
        case .mediaWaveform: return Color(red: 0.02, green: 0.85, blue: 0.83)
        case .cyberpunk: return Color(red: 0.1, green: 0.95, blue: 0.55)
        case .compactSheet: return Color(red: 0.18, green: 0.65, blue: 0.45)
        case .minimalistEditorial: return Color(red: 0.85, green: 0.72, blue: 0.52)
        case .spatialImmersive: return Color(red: 0.40, green: 0.20, blue: 0.95)
        case .beforeAfterSlider: return Color(red: 0.38, green: 0.35, blue: 0.98)
        case .videoHeroCinematic: return Color(red: 0.95, green: 0.25, blue: 0.35)
        case .fitnessRingsMetrics: return Color(red: 0.98, green: 0.15, blue: 0.35)
        case .quizResultsPersonalized: return Color(red: 0.25, green: 0.55, blue: 0.95)
        case .financeWealthClean: return Color(red: 0.10, green: 0.65, blue: 0.40)
        case .socialProofWall: return Color(red: 0.95, green: 0.40, blue: 0.15)
        case .aiPromptTokensMeter: return Color(red: 0.55, green: 0.35, blue: 0.98)
        case .documentScannerPDF: return Color(red: 0.12, green: 0.58, blue: 0.95)
        case .vpnSecurityShield: return Color(red: 0.15, green: 0.85, blue: 0.55)
        case .meditationSleepSoundscape: return Color(red: 0.62, green: 0.52, blue: 0.98)
        case .languageVocabMastery: return Color(red: 0.98, green: 0.45, blue: 0.15)
        case .travelFlightTracker: return Color(red: 0.10, green: 0.60, blue: 0.98)
        case .retroArcadeGaming: return Color(red: 0.95, green: 0.20, blue: 0.50)
        case .podcastAudiobookPlayer: return Color(red: 0.95, green: 0.40, blue: 0.25)
            
        case .specialOffer: return Color(red: 0.95, green: 0.25, blue: 0.35)
        case .flashSale: return Color(red: 0.95, green: 0.25, blue: 0.25)
        case .twoTierUpgrade: return Color(red: 0.95, green: 0.65, blue: 0.15)
        case .scratchToReveal: return Color(red: 0.95, green: 0.70, blue: 0.15)
        case .winBackRetention: return Color(red: 0.20, green: 0.65, blue: 0.50)
        case .spinToWinWheel: return Color(red: 1.0, green: 0.65, blue: 0.0)
        case .holidaySeasonalGift: return Color(red: 0.85, green: 0.15, blue: 0.20)
        case .studentCreatorGrant: return Color(red: 0.15, green: 0.45, blue: 0.95)
        case .abandonedCartNotification: return Color(red: 0.12, green: 0.55, blue: 0.95)
        case .annualVsMonthlyFrictionKiller: return Color(red: 0.10, green: 0.80, blue: 0.55)
        case .earlyBirdLaunch: return Color(red: 0.95, green: 0.78, blue: 0.25)
        case .founderPersonalLetter: return Color(red: 0.88, green: 0.40, blue: 0.35)
        case .payWhatYouWantSliding: return Color(red: 0.20, green: 0.75, blue: 0.95)
        case .referAFriendUnlock: return Color(red: 0.15, green: 0.75, blue: 0.55)
        case .seasonalNeonFlash: return Color(red: 1.0, green: 0.15, blue: 0.60)
        case .limitedSpotsRemaining: return Color(red: 0.20, green: 0.85, blue: 0.45)
        case .familySharingSplit: return Color(red: 0.35, green: 0.60, blue: 0.98)
        }
    }
    
    public var tag: String {
        switch self {
        case .bento: return "Top Seller"
        case .timeline: return "Highest Conversion"
        case .habitStreak: return "Gamified"
        case .comparisonMatrix: return "SaaS / Pro"
        case .mediaWaveform: return "Interactive Audio"
        case .cyberpunk: return "Neo-Brutalism"
        case .compactSheet: return "Biometric Sheet"
        case .minimalistEditorial: return "Luxury Serif"
        case .spatialImmersive: return "visionOS 3D"
        case .beforeAfterSlider: return "Interactive Drag"
        case .videoHeroCinematic: return "ProRes Cinema"
        case .fitnessRingsMetrics: return "Activity Rings"
        case .quizResultsPersonalized: return "Quiz Roadmap"
        case .financeWealthClean: return "Wealth Growth"
        case .socialProofWall: return "Wall of Love"
        case .aiPromptTokensMeter: return "AI Token Meter"
        case .documentScannerPDF: return "Laser Scanner"
        case .vpnSecurityShield: return "Radar Shield"
        case .meditationSleepSoundscape: return "Sleep Sanctuary"
        case .languageVocabMastery: return "Polyglot Card"
        case .travelFlightTracker: return "Boarding Pass"
        case .retroArcadeGaming: return "8-Bit Arcade"
        case .podcastAudiobookPlayer: return "Vinyl Audio EQ"
            
        case .specialOffer: return "Exit Downsell"
        case .flashSale: return "24H Urgency"
        case .twoTierUpgrade: return "Value Math"
        case .scratchToReveal: return "Mystery Confetti"
        case .winBackRetention: return "Community Grant"
        case .spinToWinWheel: return "Lucky Wheel"
        case .holidaySeasonalGift: return "Seasonal Gift"
        case .studentCreatorGrant: return "Edu Aid"
        case .abandonedCartNotification: return "iOS Push Alert"
        case .annualVsMonthlyFrictionKiller: return "Zero Friction"
        case .earlyBirdLaunch: return "Founding 500"
        case .founderPersonalLetter: return "Founder Letter"
        case .payWhatYouWantSliding: return "Sliding Scale"
        case .referAFriendUnlock: return "Give 50/Get 50"
        case .seasonalNeonFlash: return "Cyber Flash 70%"
        case .limitedSpotsRemaining: return "Geo Hold Timer"
        case .familySharingSplit: return "Split $0.83/mo"
        }
    }
}

public struct ShowcaseCatalogView: View {
    @State private var selectedCategory: PaywallCategory = .all
    @State private var selectedTemplate: PaywallTemplateType?
    @State private var showDownsellSheet: Bool = false
    @State private var enableDownsellOnExit: Bool = true
    @State private var isMockMode: Bool = true
    @State private var revenueCatApiKey: String = ""
    @State private var showSettingsSheet: Bool = false
    @State private var successAlertMessage: String?
    @State private var showSuccessAlert: Bool = false
    
    public init() {}
    
    private var filteredTemplates: [PaywallTemplateType] {
        switch selectedCategory {
        case .all: return PaywallTemplateType.allCases
        case .general: return PaywallTemplateType.allCases.filter { $0.category == .general }
        case .discounts: return PaywallTemplateType.allCases.filter { $0.category == .discounts }
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Hero Intro Banner
                    heroBanner
                    
                    // Exit Downsell Status Banner
                    downsellToggleBanner
                    
                    // Mode Switcher Banner
                    modeStatusCard
                    
                    // Category Filter Segmented Control
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(PaywallCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Template Gallery Cards
                    VStack(spacing: 14) {
                        ForEach(filteredTemplates) { template in
                            templateCard(template)
                        }
                    }
                    
                    // Footer
                    Text("SwiftUI RevenueCat Paywalls • Pinned Bottom Dock & Micro-Animations")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Paywall Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSettingsSheet = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .fullScreenCover(item: $selectedTemplate) { template in
                destinationPaywall(for: template)
            }
            .sheet(isPresented: $showDownsellSheet) {
                SpecialOfferDownsellPaywallView(
                    manager: PaywallManager(isMockMode: isMockMode),
                    onDismiss: { showDownsellSheet = false },
                    onPurchaseSuccess: {
                        showDownsellSheet = false
                        triggerSuccessAlert("Lifetime Exit Deal Claimed at 75% OFF!")
                    }
                )
            }
            .sheet(isPresented: $showSettingsSheet) {
                settingsSheet
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(successAlertMessage ?? "Purchase simulation successful!")
            }
        }
    }
    
    // MARK: - Hero Banner
    
    private var heroBanner: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("40 PRODUCTION TEMPLATES READY")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("The Complete Paywall Library")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                Spacer()
                
                Image(systemName: "rectangle.stack.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.accentColor)
                    .padding(12)
                    .background(Color.accentColor.opacity(0.12), in: Circle())
            }
            
            Text("RevenueCat-backed SwiftUI paywalls with stationary pinned docks, zero text clipping, interactive gestures, and downsell mechanics.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
    
    // MARK: - Exit Downsell Toggle
    
    private var downsellToggleBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: enableDownsellOnExit ? "arrow.uturn.backward.circle.fill" : "arrow.uturn.backward.circle")
                .font(.system(size: 22))
                .foregroundColor(enableDownsellOnExit ? .orange : .secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Exit Intent Downsell Mechanism")
                    .font(.system(size: 13, weight: .semibold))
                Text(enableDownsellOnExit ? "Triggers a 75% OFF rescue offer on dismiss" : "Direct dismiss without secondary rescue offer")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $enableDownsellOnExit)
                .labelsHidden()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(enableDownsellOnExit ? Color.orange.opacity(0.08) : Color(uiColor: .secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(enableDownsellOnExit ? Color.orange.opacity(0.25) : Color.clear, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Mode Card
    
    private var modeStatusCard: some View {
        HStack(spacing: 10) {
            Label(isMockMode ? "Mock Preview Mode Active" : "Live RevenueCat Mode Active",
                  systemImage: isMockMode ? "sparkles" : "network")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(isMockMode ? .purple : .green)
            
            Spacer()
            
            Button("Configure") {
                showSettingsSheet = true
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isMockMode ? Color.purple.opacity(0.08) : Color.green.opacity(0.08))
        )
    }
    
    // MARK: - Template Card
    
    private func templateCard(_ template: PaywallTemplateType) -> some View {
        Button(action: {
            HapticFeedback.light()
            selectedTemplate = template
        }) {
            HStack(spacing: 14) {
                // Icon Box
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(template.accentColor.opacity(0.14))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: template.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(template.accentColor)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(template.rawValue)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                        
                        Text(template.tag)
                            .font(.system(size: 9, weight: .black, design: .rounded))
                            .foregroundColor(template.accentColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(template.accentColor.opacity(0.12), in: Capsule())
                            .lineLimit(1)
                    }
                    
                    Text(template.subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.primary.opacity(0.04), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Destination Paywall Router (All 40 Templates)
    
    @ViewBuilder
    private func destinationPaywall(for template: PaywallTemplateType) -> some View {
        let manager = PaywallManager(isMockMode: isMockMode)
        
        switch template {
        // --- General Archetypes (23) ---
        case .bento:
            BentoPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .bento) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Bento Pro Membership Activated!")
                }
            )
            
        case .timeline:
            TimelineTrialPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .timeline) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("7-Day Free Trial started successfully!")
                }
            )
            
        case .habitStreak:
            HabitStreakPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .habitStreak) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Habit Streak Pro Pass Activated!")
                }
            )
            
        case .comparisonMatrix:
            ComparisonMatrixPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .comparisonMatrix) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Full Feature Matrix unlocked!")
                }
            )
            
        case .mediaWaveform:
            MediaWaveformPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .mediaWaveform) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Audio Master Studio unlocked!")
                }
            )
            
        case .cyberpunk:
            CyberpunkPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .cyberpunk) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Neo-Brutalist Pass Activated!")
                }
            )
            
        case .compactSheet:
            CompactSheetPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .compactSheet) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Fast checkout completed!")
                }
            )
            
        case .minimalistEditorial:
            MinimalistEditorialPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .minimalistEditorial) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Editorial Membership started successfully!")
                }
            )
            
        case .spatialImmersive:
            SpatialImmersivePaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .spatialImmersive) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Spatial Studio Access unlocked!")
                }
            )
            
        case .beforeAfterSlider:
            BeforeAfterSliderPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .beforeAfterSlider) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Pro Quality unlocked via Interactive Preview!")
                }
            )
            
        case .videoHeroCinematic:
            VideoHeroCinematicPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .videoHeroCinematic) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Cinema Pro Master Studio Unlocked!")
                }
            )
            
        case .fitnessRingsMetrics:
            FitnessRingsMetricsPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .fitnessRingsMetrics) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Fitness Rings Pro Activated!")
                }
            )
            
        case .quizResultsPersonalized:
            QuizResultsPersonalizedPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .quizResultsPersonalized) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Personalized Plan Roadmap Claimed!")
                }
            )
            
        case .financeWealthClean:
            FinanceWealthCleanPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .financeWealthClean) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Wealth Pro Dashboard Activated!")
                }
            )
            
        case .socialProofWall:
            SocialProofWallPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .socialProofWall) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Welcome to the 50,000+ Pro Community!")
                }
            )
            
        case .aiPromptTokensMeter:
            AIPromptTokensMeterPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .aiPromptTokensMeter) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Unlimited AI Tokens & Models Unlocked!")
                }
            )
            
        case .documentScannerPDF:
            DocumentScannerPDFPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .documentScannerPDF) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Unlimited Document & OCR Scans Unlocked!")
                }
            )
            
        case .vpnSecurityShield:
            VPNSecurityShieldPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .vpnSecurityShield) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("UltraShield Military-Grade VPN Activated!")
                }
            )
            
        case .meditationSleepSoundscape:
            MeditationSleepSoundscapePaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .meditationSleepSoundscape) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Deep Sleep Sanctuary Unlocked!")
                }
            )
            
        case .languageVocabMastery:
            LanguageVocabMasteryPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .languageVocabMastery) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Super Polyglot Fluency Pass Activated!")
                }
            )
            
        case .travelFlightTracker:
            TravelFlightTrackerPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .travelFlightTracker) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Global Radar & Flight Alerts Activated!")
                }
            )
            
        case .retroArcadeGaming:
            RetroArcadeGamingPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .retroArcadeGaming) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Retro Arcade Pro Pass Activated!")
                }
            )
            
        case .podcastAudiobookPlayer:
            PodcastAudiobookPlayerPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .podcastAudiobookPlayer) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Master Audio & Audiobook Suite Unlocked!")
                }
            )
            
        // --- Discount & Exit-Intent Offers (17) ---
        case .specialOffer:
            SpecialOfferDownsellPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Lifetime Deal Claimed at 75% OFF!")
                }
            )
            
        case .flashSale:
            FlashSaleBannerPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Flash Sale 70% Discount Claimed!")
                }
            )
            
        case .twoTierUpgrade:
            TwoTierUpgradeDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Lifetime VIP Pass Activated!")
                }
            )
            
        case .scratchToReveal:
            ScratchToRevealDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Mystery Discount Voucher Claimed!")
                }
            )
            
        case .winBackRetention:
            WinBackRetentionPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("50% Community Grant Accepted!")
                }
            )
            
        case .spinToWinWheel:
            SpinToWinWheelDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("70% Lucky Wheel Discount Claimed!")
                }
            )
            
        case .holidaySeasonalGift:
            HolidaySeasonalGiftDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Holiday Gift Pass Unwrapped!")
                }
            )
            
        case .studentCreatorGrant:
            StudentCreatorGrantDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Student & Creator Aid Grant Claimed!")
                }
            )
            
        case .abandonedCartNotification:
            AbandonedCartNotificationDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("$20 Reserved Voucher Claimed!")
                }
            )
            
        case .annualVsMonthlyFrictionKiller:
            AnnualVsMonthlyFrictionKillerPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Zero-Friction Membership Started!")
                }
            )
            
        case .earlyBirdLaunch:
            EarlyBirdLaunchDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Founding Member Spot Locked In!")
                }
            )
            
        case .founderPersonalLetter:
            FounderPersonalLetterDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Thank you for supporting indie development!")
                }
            )
            
        case .payWhatYouWantSliding:
            PayWhatYouWantSlidingDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Custom Supporter Tier Confirmed!")
                }
            )
            
        case .referAFriendUnlock:
            ReferAFriendUnlockDiscountPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("50% Peer Referral Rate Activated!")
                }
            )
            
        case .seasonalNeonFlash:
            SeasonalSpringBlackFridayDarkNeonPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("70% Cyber Neon Flash Deal Claimed!")
                }
            )
            
        case .limitedSpotsRemaining:
            LimitedSpotsRemainingScarcityPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Reserved Region Rate Guaranteed!")
                }
            )
            
        case .familySharingSplit:
            FamilySharingSplitBillingPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("iCloud Family Sharing Pass Activated!")
                }
            )
        }
    }
    
    private func handlePaywallDismissal(from template: PaywallTemplateType) {
        selectedTemplate = nil
        
        // If exit downsell is enabled and not closing a discount offer itself, present the special offer!
        if enableDownsellOnExit && template.category != .discounts {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                showDownsellSheet = true
            }
        }
    }
    
    private func triggerSuccessAlert(_ message: String) {
        successAlertMessage = message
        showSuccessAlert = true
    }
    
    // MARK: - Settings Sheet
    
    private var settingsSheet: some View {
        NavigationStack {
            Form {
                Section("Preview Configuration") {
                    Toggle("Mock Mode (Offline Previews)", isOn: $isMockMode)
                    
                    if !isMockMode {
                        SecureField("RevenueCat Public API Key", text: $revenueCatApiKey)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                
                Section("Conversion Mechanics") {
                    Toggle("Enable Downsell on Exit", isOn: $enableDownsellOnExit)
                }
                
                Section("About Paywall Studio") {
                    LabeledContent("Total Templates", value: "\(PaywallTemplateType.allCases.count)")
                    LabeledContent("General Archetypes", value: "\(PaywallTemplateType.allCases.filter { $0.category == .general }.count)")
                    LabeledContent("Discount & Downsells", value: "\(PaywallTemplateType.allCases.filter { $0.category == .discounts }.count)")
                    LabeledContent("RevenueCat SDK", value: "v5.0+")
                    LabeledContent("Layout Engine", value: "Pinned Bottom Dock")
                }
            }
            .navigationTitle("Paywall Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showSettingsSheet = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview("Paywall Showcase Catalog") {
    ShowcaseCatalogView()
}
