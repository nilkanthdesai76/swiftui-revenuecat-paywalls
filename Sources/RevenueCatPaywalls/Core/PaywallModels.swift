import SwiftUI
import RevenueCat

// MARK: - Package Type Classification

public enum PaywallPackageKind: String, Sendable, CaseIterable {
    case annual = "annual"
    case monthly = "monthly"
    case weekly = "weekly"
    case lifetime = "lifetime"
    case custom = "custom"
}

// MARK: - Paywall Package Protocol & Concrete Model

/// Represents a purchasable plan, bridging both live RevenueCat `Package` objects and offline/preview mocks.
public struct PaywallPackage: Identifiable, Sendable, Hashable {
    public let id: String
    public let identifier: String
    public let kind: PaywallPackageKind
    public let title: String
    public let localizedPriceString: String
    public let priceValue: Decimal
    public let currencySymbol: String
    public let periodSubtitle: String
    public let introTrialText: String?
    public let hasFreeTrial: Bool
    public var badgeText: String?
    public var weeklyEquivalentString: String?
    public var isBestValue: Bool
    
    /// Reference to the underlying RevenueCat SDK package (nil when running mock / preview mode)
    public let revenueCatPackage: Package?
    
    public init(
        id: String,
        identifier: String,
        kind: PaywallPackageKind,
        title: String,
        localizedPriceString: String,
        priceValue: Decimal,
        currencySymbol: String = "$",
        periodSubtitle: String,
        introTrialText: String? = nil,
        hasFreeTrial: Bool = false,
        badgeText: String? = nil,
        weeklyEquivalentString: String? = nil,
        isBestValue: Bool = false,
        revenueCatPackage: Package? = nil
    ) {
        self.id = id
        self.identifier = identifier
        self.kind = kind
        self.title = title
        self.localizedPriceString = localizedPriceString
        self.priceValue = priceValue
        self.currencySymbol = currencySymbol
        self.periodSubtitle = periodSubtitle
        self.introTrialText = introTrialText
        self.hasFreeTrial = hasFreeTrial
        self.badgeText = badgeText
        self.weeklyEquivalentString = weeklyEquivalentString
        self.isBestValue = isBestValue
        self.revenueCatPackage = revenueCatPackage
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(identifier)
    }
    
    public static func == (lhs: PaywallPackage, rhs: PaywallPackage) -> Bool {
        lhs.id == rhs.id && lhs.identifier == rhs.identifier
    }
}

// MARK: - Paywall Feature Item

public struct PaywallFeatureItem: Identifiable, Sendable, Hashable {
    public let id: UUID
    public let icon: String
    public let title: String
    public let subtitle: String
    public let accentColorHex: String?
    
    public init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        subtitle: String,
        accentColorHex: String? = nil
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.accentColorHex = accentColorHex
    }
}

// MARK: - Feature Comparison Row (For Comparison Matrix Archetype)

public struct PaywallComparisonRow: Identifiable, Sendable, Hashable {
    public let id: UUID
    public let featureName: String
    public let freeTierValue: String
    public let proTierValue: String
    public let isProExclusive: Bool
    
    public init(
        id: UUID = UUID(),
        featureName: String,
        freeTierValue: String,
        proTierValue: String,
        isProExclusive: Bool = false
    ) {
        self.id = id
        self.featureName = featureName
        self.freeTierValue = freeTierValue
        self.proTierValue = proTierValue
        self.isProExclusive = isProExclusive
    }
}

// MARK: - Trial Timeline Step (For Apple Timeline Archetype)

public enum TimelineStepStatus: Sendable {
    case completed
    case active
    case upcoming
}

public struct TrialTimelineStep: Identifiable, Sendable {
    public let id: Int
    public let dayLabel: String
    public let title: String
    public let detail: String
    public let icon: String
    public let status: TimelineStepStatus
    
    public init(
        id: Int,
        dayLabel: String,
        title: String,
        detail: String,
        icon: String,
        status: TimelineStepStatus
    ) {
        self.id = id
        self.dayLabel = dayLabel
        self.title = title
        self.detail = detail
        self.icon = icon
        self.status = status
    }
}

// MARK: - Social Proof / Testimonial

public struct PaywallTestimonial: Identifiable, Sendable {
    public let id: UUID
    public let authorName: String
    public let handleOrSource: String
    public let stars: Int
    public let comment: String
    
    public init(
        id: UUID = UUID(),
        authorName: String,
        handleOrSource: String,
        stars: Int = 5,
        comment: String
    ) {
        self.id = id
        self.authorName = authorName
        self.handleOrSource = handleOrSource
        self.stars = stars
        self.comment = comment
    }
}

// MARK: - Global Configuration

public struct PaywallConfiguration: Sendable {
    public var appTitle: String
    public var appSubtitle: String
    public var appIconSystemName: String
    public var closeDelaySeconds: Double
    public var termsURL: URL?
    public var privacyURL: URL?
    public var primaryThemeColor: Color
    public var secondaryThemeColor: Color
    
    public init(
        appTitle: String = "Pro Access",
        appSubtitle: String = "Unlock all premium features without limits",
        appIconSystemName: String = "crown.fill",
        closeDelaySeconds: Double = 0.0,
        termsURL: URL? = URL(string: "https://example.com/terms"),
        privacyURL: URL? = URL(string: "https://example.com/privacy"),
        primaryThemeColor: Color = Color(red: 0.38, green: 0.35, blue: 0.98),
        secondaryThemeColor: Color = Color(red: 0.65, green: 0.35, blue: 0.98)
    ) {
        self.appTitle = appTitle
        self.appSubtitle = appSubtitle
        self.appIconSystemName = appIconSystemName
        self.closeDelaySeconds = closeDelaySeconds
        self.termsURL = termsURL
        self.privacyURL = privacyURL
        self.primaryThemeColor = primaryThemeColor
        self.secondaryThemeColor = secondaryThemeColor
    }
}
