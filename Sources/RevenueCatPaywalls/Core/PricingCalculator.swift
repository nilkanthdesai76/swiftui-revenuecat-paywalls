import Foundation
import RevenueCat

/// Helper engine for computing subscription discounts, weekly equivalent rates, and trial terms.
public enum PricingCalculator {
    
    /// Normalizes raw RevenueCat `Package` instances into rich `PaywallPackage` items with auto-computed savings.
    public static func processPackages(_ packages: [Package]) -> [PaywallPackage] {
        var results: [PaywallPackage] = []
        
        // Find monthly package if present to calculate annual discount
        let monthlyPackage = packages.first { $0.packageType == .monthly }
        let monthlyPrice = monthlyPackage?.storeProduct.price ?? 0
        
        for package in packages {
            let product = package.storeProduct
            let kind = mapPackageType(package.packageType)
            
            // Format title
            let title = titleForPackage(package)
            
            // Period subtitle
            let periodSubtitle = subtitleForPackage(package)
            
            // Free trial detection
            let (hasTrial, trialText) = extractTrialInfo(product: product)
            
            // Weekly equivalent
            let weeklyString = calculateWeeklyEquivalent(product: product, kind: kind)
            
            // Savings calculation
            var badgeText: String? = nil
            var isBestValue = false
            
            if kind == .annual {
                isBestValue = true
                if monthlyPrice > 0 {
                    let annualPerMonth = product.price / 12
                    let ratio = NSDecimalNumber(decimal: annualPerMonth / monthlyPrice).doubleValue
                    let savingsPercent = Int(round((1.0 - ratio) * 100.0))
                    if savingsPercent > 5 {
                        badgeText = "SAVE \(savingsPercent)%"
                    } else {
                        badgeText = "BEST VALUE"
                    }
                } else {
                    badgeText = "BEST VALUE"
                }
            } else if kind == .lifetime {
                badgeText = "ONE-TIME"
            }
            
            let item = PaywallPackage(
                id: package.identifier,
                identifier: package.identifier,
                kind: kind,
                title: title,
                localizedPriceString: product.localizedPriceString,
                priceValue: product.price,
                currencySymbol: product.currencyCode ?? "$",
                periodSubtitle: periodSubtitle,
                introTrialText: trialText,
                hasFreeTrial: hasTrial,
                badgeText: badgeText,
                weeklyEquivalentString: weeklyString,
                isBestValue: isBestValue,
                revenueCatPackage: package
            )
            
            results.append(item)
        }
        
        return results
    }
    
    private static func mapPackageType(_ type: PackageType) -> PaywallPackageKind {
        switch type {
        case .annual: return .annual
        case .monthly: return .monthly
        case .weekly: return .weekly
        case .lifetime: return .lifetime
        default: return .custom
        }
    }
    
    private static func titleForPackage(_ package: Package) -> String {
        switch package.packageType {
        case .annual: return "Yearly Access"
        case .monthly: return "Monthly Access"
        case .weekly: return "Weekly Access"
        case .lifetime: return "Lifetime License"
        default: return package.storeProduct.localizedTitle
        }
    }
    
    private static func subtitleForPackage(_ package: Package) -> String {
        switch package.packageType {
        case .annual: return "/ year"
        case .monthly: return "/ month"
        case .weekly: return "/ week"
        case .lifetime: return "one-time payment"
        default: return ""
        }
    }
    
    private static func extractTrialInfo(product: StoreProduct) -> (Bool, String?) {
        guard let intro = product.introductoryDiscount, intro.paymentMode == .freeTrial else {
            return (false, nil)
        }
        
        let period = intro.subscriptionPeriod
        let value = period.value
        let unitString: String
        switch period.unit {
        case .day: unitString = value == 1 ? "day" : "days"
        case .week: unitString = value == 1 ? "week" : "weeks"
        case .month: unitString = value == 1 ? "month" : "months"
        case .year: unitString = value == 1 ? "year" : "years"
        @unknown default: unitString = "days"
        }
        
        return (true, "\(value)-\(unitString) free trial")
    }
    
    private static func calculateWeeklyEquivalent(product: StoreProduct, kind: PaywallPackageKind) -> String? {
        guard kind == .annual else { return nil }
        
        let price = product.price
        let weeklyPrice = price / 52
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let currencyCode = product.currencyCode {
            formatter.currencyCode = currencyCode
        }
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let formatted = formatter.string(from: weeklyPrice as NSDecimalNumber) {
            return "\(formatted) / week"
        }
        return nil
    }
}
