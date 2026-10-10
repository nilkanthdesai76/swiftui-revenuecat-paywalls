import XCTest
@testable import RevenueCatPaywalls

final class RevenueCatPaywallsTests: XCTestCase {
    
    func testMockPackagesIntegrity() {
        let packages = MockData.samplePackages
        XCTAssertEqual(packages.count, 3)
        
        let annual = packages.first { $0.kind == .annual }
        XCTAssertNotNil(annual)
        XCTAssertTrue(annual!.hasFreeTrial)
        XCTAssertEqual(annual!.badgeText, "SAVE 68%")
        XCTAssertNotNil(annual!.weeklyEquivalentString)
        XCTAssertTrue(annual!.isBestValue)
        
        let monthly = packages.first { $0.kind == .monthly }
        XCTAssertNotNil(monthly)
        XCTAssertFalse(monthly!.hasFreeTrial)
        
        let lifetime = packages.first { $0.kind == .lifetime }
        XCTAssertNotNil(lifetime)
        XCTAssertEqual(lifetime!.badgeText, "FOREVER")
    }
    
    @MainActor
    func testPaywallManagerMockSelection() {
        let manager = PaywallManager(isMockMode: true)
        XCTAssertEqual(manager.packages.count, 3)
        XCTAssertEqual(manager.selectedPackage?.kind, .annual)
        XCTAssertTrue(manager.isFreeTrialEnabled)
        
        // Select monthly
        if let monthly = manager.packages.first(where: { $0.kind == .monthly }) {
            manager.selectPackage(monthly)
            XCTAssertEqual(manager.selectedPackage?.id, monthly.id)
            XCTAssertFalse(manager.isFreeTrialEnabled)
        }
    }
    
    @MainActor
    func testPaywallManagerTrialToggle() {
        let manager = PaywallManager(isMockMode: true)
        XCTAssertTrue(manager.isFreeTrialEnabled)
        
        // Toggle trial off -> switches to non-trial plan
        manager.toggleFreeTrial(enabled: false)
        XCTAssertFalse(manager.isFreeTrialEnabled)
        XCTAssertFalse(manager.selectedPackage?.hasFreeTrial ?? true)
        
        // Toggle trial on -> switches to trial-eligible plan
        manager.toggleFreeTrial(enabled: true)
        XCTAssertTrue(manager.isFreeTrialEnabled)
        XCTAssertTrue(manager.selectedPackage?.hasFreeTrial ?? false)
    }
    
    @MainActor
    func testMockPurchaseSimulation() async {
        let manager = PaywallManager(isMockMode: true)
        XCTAssertFalse(manager.purchaseSuccess)
        
        let success = await manager.purchaseSelected()
        XCTAssertTrue(success)
        XCTAssertTrue(manager.purchaseSuccess)
    }
    
    @MainActor
    func testMockRestoreSimulation() async {
        let manager = PaywallManager(isMockMode: true)
        XCTAssertFalse(manager.restoreSuccess)
        
        let success = await manager.restorePurchases()
        XCTAssertTrue(success)
        XCTAssertTrue(manager.restoreSuccess)
    }
}
