import SwiftUI
import RevenueCatPaywalls

public enum PaywallTemplateType: String, CaseIterable, Identifiable {
    case bento = "Glassmorphic Bento"
    case timeline = "Apple Timeline Trial"
    case habitStreak = "Habit Streak & Social Proof"
    case comparisonMatrix = "Feature Comparison Matrix"
    case mediaWaveform = "Media Waveform & Pulse"
    case cyberpunk = "Cyberpunk Neo-Brutalist"
    case compactSheet = "Compact Sheet Modal"
    
    public var id: String { rawValue }
    
    public var subtitle: String {
        switch self {
        case .bento: return "Spatial blur tiles & interactive micro-widgets for AI / productivity"
        case .timeline: return "3-step visual trial timeline with toggle (App Store #1 layout)"
        case .habitStreak: return "Gamified streak flame rings & milestone roadmap for fitness/habits"
        case .comparisonMatrix: return "Side-by-side Free vs Pro table with checkmarks & feature rows"
        case .mediaWaveform: return "Pulsing audio visualizer & studio master tracks for audio/music"
        case .cyberpunk: return "High-contrast neon borders & monospaced tags for dev/crypto tools"
        case .compactSheet: return "Sleek half-sheet with biometrics icon & 1-tap fast checkout"
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
        case .compactSheet: return "doc.text.fill"
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
        }
    }
    
    public var tag: String {
        switch self {
        case .bento: return "Top Seller"
        case .timeline: return "Highest Conversion"
        case .habitStreak: return "Gamified"
        case .comparisonMatrix: return "SaaS / Pro"
        case .mediaWaveform: return "Dark Studio"
        case .cyberpunk: return "Neo-Brutalism"
        case .compactSheet: return "Quick Modal"
        }
    }
}

public struct ShowcaseCatalogView: View {
    @State private var selectedTemplate: PaywallTemplateType?
    @State private var isMockMode: Bool = true
    @State private var revenueCatApiKey: String = ""
    @State private var showSettingsSheet: Bool = false
    @State private var successAlertMessage: String?
    @State private var showSuccessAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Hero Intro Banner
                    heroBanner
                    
                    // Mode Switcher Banner
                    modeStatusCard
                    
                    // Template Gallery Cards
                    VStack(spacing: 16) {
                        ForEach(PaywallTemplateType.allCases) { template in
                            templateCard(template)
                        }
                    }
                    
                    // Footer
                    Text("SwiftUI RevenueCat Paywalls • Designed for maximum conversion")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 20)
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
                
                Text("7 Archetypes")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
            }
            
            Text("High-Converting Paywall Templates")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("Designer-grade, interactive paywalls for any iOS app. Tap any card below to interact with live package purchasing, trial toggling, and restore flows.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(3)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 10, y: 4)
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
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
    }
    
    // MARK: - Template Card
    
    private func templateCard(_ template: PaywallTemplateType) -> some View {
        Button(action: {
            HapticFeedback.light()
            selectedTemplate = template
        }) {
            HStack(spacing: 16) {
                // Leading Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(template.accentColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: template.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(template.accentColor)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(template.rawValue)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(template.tag)
                            .font(.system(size: 9.5, weight: .bold, design: .rounded))
                            .foregroundColor(template.accentColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(template.accentColor.opacity(0.12), in: Capsule())
                    }
                    
                    Text(template.subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.03), radius: 8, y: 3)
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
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Bento Paywall purchase simulated successfully!")
                }
            )
            
        case .timeline:
            TimelineTrialPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("7-Day Free Trial activated successfully!")
                }
            )
            
        case .habitStreak:
            HabitStreakPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Habit Streak Pass activated!")
                }
            )
            
        case .comparisonMatrix:
            ComparisonMatrixPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Upgraded to Pro via Comparison Matrix!")
                }
            )
            
        case .mediaWaveform:
            MediaWaveformPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Studio Master Access unlocked!")
                }
            )
            
        case .cyberpunk:
            CyberpunkPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Root Access Granted!")
                }
            )
            
        case .compactSheet:
            CompactSheetPaywallView(
                manager: manager,
                onDismiss: { selectedTemplate = nil },
                onPurchaseSuccess: {
                    selectedTemplate = nil
                    triggerSuccessAlert("Fast checkout completed!")
                }
            )
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
                
                Section("About Paywall Studio") {
                    LabeledContent("Total Templates", value: "\(PaywallTemplateType.allCases.count)")
                    LabeledContent("RevenueCat SDK", value: "v5.0+")
                    LabeledContent("SwiftUI Target", value: "iOS 16+ / macOS 13+")
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
