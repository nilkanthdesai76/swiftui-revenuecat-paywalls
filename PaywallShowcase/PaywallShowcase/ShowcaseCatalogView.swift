import SwiftUI
import RevenueCatPaywalls

public enum PaywallCategory: String, CaseIterable, Identifiable {
    case all = "All (15)"
    case general = "General Archetypes (10)"
    case discounts = "Discount Offers (5)"
    
    public var id: String { rawValue }
}

public enum PaywallTemplateType: String, CaseIterable, Identifiable {
    // General Archetypes
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
    
    // Discount & Exit-Intent Offer Designs
    case specialOffer = "Exit-Offer Special Downsell"
    case flashSale = "24H Flash Sale Event"
    case twoTierUpgrade = "Lifetime VIP Value Anchor"
    case scratchToReveal = "Scratch & Reveal Mystery Deal"
    case winBackRetention = "Empathetic Win-Back Offer"
    
    public var id: String { rawValue }
    
    public var category: PaywallCategory {
        switch self {
        case .bento, .timeline, .habitStreak, .comparisonMatrix, .mediaWaveform, .cyberpunk, .compactSheet, .minimalistEditorial, .spatialImmersive, .beforeAfterSlider:
            return .general
        case .specialOffer, .flashSale, .twoTierUpgrade, .scratchToReveal, .winBackRetention:
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
        case .specialOffer: return "Exit-intent 1-offering deal with live ticking timer & 75% OFF badge"
        case .flashSale: return "Urgency marquee ticker, claim meter & instant voucher coupon code"
        case .twoTierUpgrade: return "Value math breakdown comparing recurring annual vs lifetime pass"
        case .scratchToReveal: return "Gamified scratch-off mystery voucher with celebratory confetti particles"
        case .winBackRetention: return "Empathetic indie developer 50% community grant for price-sensitive users"
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
        case .specialOffer: return "tag.fill"
        case .flashSale: return "bolt.fill"
        case .twoTierUpgrade: return "crown.fill"
        case .scratchToReveal: return "gift.fill"
        case .winBackRetention: return "heart.fill"
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
        case .specialOffer: return Color(red: 0.95, green: 0.25, blue: 0.35)
        case .flashSale: return Color(red: 0.95, green: 0.25, blue: 0.25)
        case .twoTierUpgrade: return Color(red: 0.95, green: 0.65, blue: 0.15)
        case .scratchToReveal: return Color(red: 0.95, green: 0.70, blue: 0.15)
        case .winBackRetention: return Color(red: 0.20, green: 0.65, blue: 0.50)
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
        case .specialOffer: return "Exit Downsell"
        case .flashSale: return "24H Urgency"
        case .twoTierUpgrade: return "Value Math"
        case .scratchToReveal: return "Mystery Confetti"
        case .winBackRetention: return "Community Grant"
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
                Text(successAlertMessage ?? "Transaction completed successfully!")
            }
        }
    }
    
    // MARK: - Hero Banner
    
    private var heroBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("REVENUECAT + SWIFTUI")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(Color(red: 0.95, green: 0.45, blue: 0.25))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.95, green: 0.45, blue: 0.25).opacity(0.12), in: Capsule())
                
                Spacer()
                
                Text("8 Archetypes")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
            }
            
            Text("High-Converting Paywall Templates")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("Sticky bottom docks keep pricing and CTA pinned. Top features scroll independently with interactive micro-animations.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(3)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.appSecondaryGroupedBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 10, y: 4)
        )
    }
    
    // MARK: - Downsell Toggle Banner
    
    private var downsellToggleBanner: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.95, green: 0.25, blue: 0.35).opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "tag.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.95, green: 0.25, blue: 0.35))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Exit-Offer Downsell Trigger")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(enableDownsellOnExit ? "Closing any paywall presents the 75% off lifetime offer" : "Closing paywall dismisses immediately")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $enableDownsellOnExit)
                .labelsHidden()
                .tint(Color(red: 0.95, green: 0.25, blue: 0.35))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appSecondaryGroupedBackground)
        )
    }
    
    // MARK: - Mode Status Card
    
    private var modeStatusCard: some View {
        HStack(spacing: 12) {
            Image(systemName: isMockMode ? "bolt.fill" : "network")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(isMockMode ? .orange : .green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isMockMode ? "Offline Mock Preview Mode Active" : "Live RevenueCat Mode Active")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(isMockMode ? "Testing realistic packages & trial flows without network" : "Connected to live RevenueCat offerings")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Configure") {
                showSettingsSheet = true
            }
            .font(.system(size: 12, weight: .semibold))
            .buttonStyle(.bordered)
            .tint(isMockMode ? .orange : .green)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appSecondaryGroupedBackground)
        )
    }
    
    // MARK: - Template Card
    
    private func templateCard(_ template: PaywallTemplateType) -> some View {
        Button(action: {
            HapticFeedback.light()
            selectedTemplate = template
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(template.accentColor.opacity(0.15))
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: template.icon)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(template.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(template.rawValue)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(template.tag)
                            .font(.system(size: 9.0, weight: .bold, design: .rounded))
                            .foregroundColor(template.accentColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(template.accentColor.opacity(0.12), in: Capsule())
                    }
                    
                    Text(template.subtitle)
                        .font(.system(size: 11.5, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.appSecondaryGroupedBackground)
                    .shadow(color: Color.black.opacity(0.03), radius: 6, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Destination Paywall Resolver
    
    @ViewBuilder
    private func destinationPaywall(for template: PaywallTemplateType) -> some View {
        let manager = PaywallManager(isMockMode: isMockMode)
        
        switch template {
        case .bento:
            BentoPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .bento) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Bento Paywall purchase simulated successfully!")
                }
            )
            
        case .timeline:
            TimelineTrialPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .timeline) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("7-Day Free Trial activated successfully!")
                }
            )
            
        case .habitStreak:
            HabitStreakPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .habitStreak) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Habit Streak Pass activated!")
                }
            )
            
        case .comparisonMatrix:
            ComparisonMatrixPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .comparisonMatrix) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Upgraded to Pro via Comparison Matrix!")
                }
            )
            
        case .mediaWaveform:
            MediaWaveformPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .mediaWaveform) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Studio Master Access unlocked!")
                }
            )
            
        case .cyberpunk:
            CyberpunkPaywallView(
                manager: manager,
                onDismiss: { handlePaywallDismissal(from: .cyberpunk) },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Root Access Granted!")
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
