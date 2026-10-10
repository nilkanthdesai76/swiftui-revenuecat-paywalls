import SwiftUI
import Combine
import RevenueCat

@MainActor
public final class PaywallManager: ObservableObject {
    
    // MARK: - Published State
    
    @Published public var packages: [PaywallPackage] = []
    @Published public var selectedPackage: PaywallPackage?
    @Published public var isLoading: Bool = false
    @Published public var isPurchasing: Bool = false
    @Published public var isRestoring: Bool = false
    @Published public var purchaseSuccess: Bool = false
    @Published public var restoreSuccess: Bool = false
    @Published public var errorMessage: String?
    @Published public var showErrorAlert: Bool = false
    
    /// Toggle state for the Apple-style "Enable Free Trial" switch
    @Published public var isFreeTrialEnabled: Bool = true
    
    /// True when running in offline preview or simulator mock mode
    public let isMockMode: Bool
    
    private let offeringIdentifier: String?
    
    // MARK: - Initializer
    
    public init(
        isMockMode: Bool = false,
        offeringIdentifier: String? = nil,
        initialPackages: [PaywallPackage] = []
    ) {
        self.isMockMode = isMockMode
        self.offeringIdentifier = offeringIdentifier
        
        if isMockMode || !initialPackages.isEmpty {
            self.packages = initialPackages.isEmpty ? MockData.samplePackages : initialPackages
            self.selectedPackage = self.packages.first { $0.isBestValue } ?? self.packages.first
            self.isFreeTrialEnabled = self.selectedPackage?.hasFreeTrial ?? false
        }
    }
    
    // MARK: - Offerings Fetch
    
    public func loadOfferings() async {
        if isMockMode {
            if packages.isEmpty {
                self.packages = MockData.samplePackages
                self.selectedPackage = self.packages.first { $0.isBestValue } ?? self.packages.first
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let offerings = try await Purchases.shared.offerings()
            let offering: Offering?
            
            if let targetId = offeringIdentifier {
                offering = offerings.offering(identifier: targetId)
            } else {
                offering = offerings.current
            }
            
            guard let offering = offering, !offering.availablePackages.isEmpty else {
                // If no live offerings configured, fallback gracefully to mock packages in dev
                self.packages = MockData.samplePackages
                self.selectedPackage = self.packages.first { $0.isBestValue } ?? self.packages.first
                self.isLoading = false
                return
            }
            
            let processed = PricingCalculator.processPackages(offering.availablePackages)
            self.packages = processed
            self.selectedPackage = processed.first { $0.isBestValue } ?? processed.first
            self.isFreeTrialEnabled = self.selectedPackage?.hasFreeTrial ?? false
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            // Fallback to sample packages so user never sees a broken UI
            if self.packages.isEmpty {
                self.packages = MockData.samplePackages
                self.selectedPackage = self.packages.first { $0.isBestValue } ?? self.packages.first
            }
        }
    }
    
    // MARK: - Selection
    
    public func selectPackage(_ package: PaywallPackage) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            self.selectedPackage = package
            self.isFreeTrialEnabled = package.hasFreeTrial
        }
        HapticFeedback.selection()
    }
    
    public func toggleFreeTrial(enabled: Bool) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            self.isFreeTrialEnabled = enabled
            if enabled {
                if let trialPlan = packages.first(where: { $0.hasFreeTrial }) {
                    self.selectedPackage = trialPlan
                }
            } else {
                if let nonTrialPlan = packages.first(where: { !$0.hasFreeTrial }) {
                    self.selectedPackage = nonTrialPlan
                }
            }
        }
        HapticFeedback.light()
    }
    
    // MARK: - Purchase Flow
    
    public func purchaseSelected() async -> Bool {
        guard let package = selectedPackage else {
            errorMessage = "No plan selected"
            showErrorAlert = true
            return false
        }
        return await purchase(package: package)
    }
    
    public func purchase(package: PaywallPackage) async -> Bool {
        isPurchasing = true
        errorMessage = nil
        
        // Mock mode simulation
        if isMockMode || package.revenueCatPackage == nil {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            self.isPurchasing = false
            self.purchaseSuccess = true
            HapticFeedback.success()
            return true
        }
        
        guard let rcPackage = package.revenueCatPackage else {
            isPurchasing = false
            errorMessage = "Package configuration unavailable"
            showErrorAlert = true
            return false
        }
        
        do {
            let result = try await Purchases.shared.purchase(package: rcPackage)
            isPurchasing = false
            
            if result.userCancelled {
                return false
            }
            
            if !result.customerInfo.entitlements.active.isEmpty {
                purchaseSuccess = true
                HapticFeedback.success()
                return true
            } else {
                purchaseSuccess = true
                HapticFeedback.success()
                return true
            }
        } catch {
            isPurchasing = false
            errorMessage = error.localizedDescription
            showErrorAlert = true
            HapticFeedback.error()
            return false
        }
    }
    
    // MARK: - Restore Purchases
    
    public func restorePurchases() async -> Bool {
        isRestoring = true
        errorMessage = nil
        
        if isMockMode {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.isRestoring = false
            self.restoreSuccess = true
            HapticFeedback.success()
            return true
        }
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            isRestoring = false
            
            if !customerInfo.entitlements.active.isEmpty {
                restoreSuccess = true
                HapticFeedback.success()
                return true
            } else {
                errorMessage = "No active subscriptions found for this Apple ID."
                showErrorAlert = true
                return false
            }
        } catch {
            isRestoring = false
            errorMessage = error.localizedDescription
            showErrorAlert = true
            HapticFeedback.error()
            return false
        }
    }
}
