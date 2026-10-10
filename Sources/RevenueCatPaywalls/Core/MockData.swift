import SwiftUI

public enum MockData {
    
    // MARK: - Sample Packages
    
    public static let sampleAnnual = PaywallPackage(
        id: "$rc_annual",
        identifier: "$rc_annual",
        kind: .annual,
        title: "Annual Pro",
        localizedPriceString: "$39.99",
        priceValue: Decimal(39.99),
        currencySymbol: "$",
        periodSubtitle: "/ year",
        introTrialText: "7-day free trial",
        hasFreeTrial: true,
        badgeText: "SAVE 68%",
        weeklyEquivalentString: "$0.77 / week",
        isBestValue: true,
        revenueCatPackage: nil
    )
    
    public static let sampleMonthly = PaywallPackage(
        id: "$rc_monthly",
        identifier: "$rc_monthly",
        kind: .monthly,
        title: "Monthly Pass",
        localizedPriceString: "$9.99",
        priceValue: Decimal(9.99),
        currencySymbol: "$",
        periodSubtitle: "/ month",
        introTrialText: nil,
        hasFreeTrial: false,
        badgeText: nil,
        weeklyEquivalentString: "$2.31 / week",
        isBestValue: false,
        revenueCatPackage: nil
    )
    
    public static let sampleLifetime = PaywallPackage(
        id: "$rc_lifetime",
        identifier: "$rc_lifetime",
        kind: .lifetime,
        title: "Lifetime License",
        localizedPriceString: "$99.99",
        priceValue: Decimal(99.99),
        currencySymbol: "$",
        periodSubtitle: "one-time payment",
        introTrialText: nil,
        hasFreeTrial: false,
        badgeText: "FOREVER",
        weeklyEquivalentString: "pay once, yours forever",
        isBestValue: false,
        revenueCatPackage: nil
    )
    
    public static let samplePackages: [PaywallPackage] = [
        sampleAnnual,
        sampleMonthly,
        sampleLifetime
    ]
    
    // MARK: - General / Productivity Features
    
    public static let sampleFeatures: [PaywallFeatureItem] = [
        PaywallFeatureItem(
            icon: "sparkles",
            title: "Unlimited AI Processing",
            subtitle: "No caps or throttling on model prompts and high-speed execution",
            accentColorHex: "#6366F1"
        ),
        PaywallFeatureItem(
            icon: "icloud.and.arrow.up.fill",
            title: "Cloud Sync Across All Macs & iPhones",
            subtitle: "Instant end-to-end encrypted synchronization without manual setup",
            accentColorHex: "#3B82F6"
        ),
        PaywallFeatureItem(
            icon: "lock.shield.fill",
            title: "Zero-Knowledge Biometric Vault",
            subtitle: "Keep your sensitive notes, tokens, and records protected by FaceID",
            accentColorHex: "#10B981"
        ),
        PaywallFeatureItem(
            icon: "bell.badge.fill",
            title: "Priority Background Reminders",
            subtitle: "Deep calendar integration with automated follow-ups and smart nudges",
            accentColorHex: "#F59E0B"
        )
    ]
    
    // MARK: - Habit & Streak Features
    
    public static let sampleHabitFeatures: [PaywallFeatureItem] = [
        PaywallFeatureItem(
            icon: "flame.fill",
            title: "Unlimited Habit Streaks",
            subtitle: "Track 50+ custom routines without hitting the 3-habit paywall cap",
            accentColorHex: "#EF4444"
        ),
        PaywallFeatureItem(
            icon: "chart.line.uptrend.xyaxis",
            title: "Advanced Bio-Rhythm Analytics",
            subtitle: "Interactive charts uncovering your peak productivity hours",
            accentColorHex: "#8B5CF6"
        ),
        PaywallFeatureItem(
            icon: "trophy.fill",
            title: "Gamified Milestone Badges",
            subtitle: "Earn exclusive animated rings and share streak achievements with friends",
            accentColorHex: "#F59E0B"
        ),
        PaywallFeatureItem(
            icon: "bolt.heart.fill",
            title: "Smart Rest Day Protection",
            subtitle: "Maintain your hard-earned streak even when life requires a pause",
            accentColorHex: "#EC4899"
        )
    ]
    
    // MARK: - Audio / Waveform Features
    
    public static let sampleAudioFeatures: [PaywallFeatureItem] = [
        PaywallFeatureItem(
            icon: "waveform.path.ecg",
            title: "Lossless Studio Quality",
            subtitle: "Record and export in pristine 24-bit / 96kHz FLAC & WAV formats",
            accentColorHex: "#06B6D4"
        ),
        PaywallFeatureItem(
            icon: "sparkle.magnifyingglass",
            title: "AI Vocal & Wind Denoising",
            subtitle: "One-tap studio clean up removing reverb, hiss, and ambient chatter",
            accentColorHex: "#3B82F6"
        ),
        PaywallFeatureItem(
            icon: "waveform.and.mic",
            title: "Real-Time Spectrum Visualizer",
            subtitle: "32-band responsive haptic equalizer while recording or playing",
            accentColorHex: "#8B5CF6"
        ),
        PaywallFeatureItem(
            icon: "infinity",
            title: "Unbounded Audio Length",
            subtitle: "No 5-minute recording limits. Capture hour-long lectures & jams",
            accentColorHex: "#10B981"
        )
    ]
    
    // MARK: - Cyberpunk / Developer Features
    
    public static let sampleCyberpunkFeatures: [PaywallFeatureItem] = [
        PaywallFeatureItem(
            icon: "terminal.fill",
            title: "CLI & Webhook Trigger Engine",
            subtitle: "Run headless automated shell scripts and trigger custom webhooks",
            accentColorHex: "#10B981"
        ),
        PaywallFeatureItem(
            icon: "cpu.fill",
            title: "Multi-Threaded Hardware Acceleration",
            subtitle: "Unleash all GPU/Neural Engine cores for ultra-low latency batches",
            accentColorHex: "#06B6D4"
        ),
        PaywallFeatureItem(
            icon: "network.badge.shield.half.filled",
            title: "Self-Hosted Private Endpoints",
            subtitle: "Bypass central proxies and route directly to your private cluster",
            accentColorHex: "#F43F5E"
        ),
        PaywallFeatureItem(
            icon: "key.fill",
            title: "Unlimited API Keys & Tokens",
            subtitle: "Store, rotate, and manage enterprise credentials securely",
            accentColorHex: "#EAB308"
        )
    ]
    
    // MARK: - Comparison Matrix Rows
    
    public static let sampleComparisonRows: [PaywallComparisonRow] = [
        PaywallComparisonRow(
            featureName: "Cloud Sync & Backup",
            freeTierValue: "1 Device",
            proTierValue: "Unlimited Devices",
            isProExclusive: true
        ),
        PaywallComparisonRow(
            featureName: "AI Processing Speed",
            freeTierValue: "Standard Queue",
            proTierValue: "Ultra Turbo (No Wait)",
            isProExclusive: true
        ),
        PaywallComparisonRow(
            featureName: "Daily Export Limit",
            freeTierValue: "3 Files / Day",
            proTierValue: "Unlimited Full HD",
            isProExclusive: true
        ),
        PaywallComparisonRow(
            featureName: "Advanced Widgets & Complications",
            freeTierValue: "Basic Only",
            proTierValue: "All 18+ Interactive",
            isProExclusive: true
        ),
        PaywallComparisonRow(
            featureName: "Ad Experience",
            freeTierValue: "Banner Ads Included",
            proTierValue: "100% Ad-Free Forever",
            isProExclusive: true
        ),
        PaywallComparisonRow(
            featureName: "Priority Developer Support",
            freeTierValue: "Community Discord",
            proTierValue: "Direct Email (<4h SLA)",
            isProExclusive: true
        )
    ]
    
    // MARK: - Apple Timeline Steps
    
    public static let sampleTimelineSteps: [TrialTimelineStep] = [
        TrialTimelineStep(
            id: 1,
            dayLabel: "Today",
            title: "Unlock Instant Full Access",
            detail: "Get 7 days free. Zero charges right now. Cancel anytime with one tap.",
            icon: "lock.open.fill",
            status: .active
        ),
        TrialTimelineStep(
            id: 2,
            dayLabel: "Day 5",
            title: "Friendly Push Notification",
            detail: "We'll send you an alert 48 hours before your trial expires so you stay in control.",
            icon: "bell.badge.fill",
            status: .upcoming
        ),
        TrialTimelineStep(
            id: 3,
            dayLabel: "Day 7",
            title: "Subscription Renews Automatically",
            detail: "Your annual membership begins at $39.99/yr ($0.77/wk). Cancel anytime in Settings.",
            icon: "star.fill",
            status: .upcoming
        )
    ]
    
    // MARK: - Social Proof / Testimonials
    
    public static let sampleTestimonials: [PaywallTestimonial] = [
        PaywallTestimonial(
            authorName: "Sarah Jenkins",
            handleOrSource: "Product Designer on App Store",
            stars: 5,
            comment: "This app replaced 3 different subscriptions for me. The 7-day trial convinced me within 10 minutes!"
        ),
        PaywallTestimonial(
            authorName: "Marcus Sterling",
            handleOrSource: "Software Engineer @ TechCorp",
            stars: 5,
            comment: "Easily the highest quality utility on macOS and iOS. Fast, gorgeous design, and totally worth the annual pass."
        ),
        PaywallTestimonial(
            authorName: "Elena Rostova",
            handleOrSource: "Verified Apple Subscriber",
            stars: 5,
            comment: "The cloud sync and zero ads alone make this an instant buy. Thank you for making a great app."
        )
    ]
}
