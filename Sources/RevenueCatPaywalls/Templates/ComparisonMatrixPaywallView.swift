import SwiftUI

public struct ComparisonMatrixPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var comparisonRows: [PaywallComparisonRow]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var hoveredRowId: UUID?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Compare Plans",
            appSubtitle: "Choose the tier that matches your workflow demands",
            appIconSystemName: "tablecells.badge.ellipsis",
            primaryThemeColor: Color(red: 0.12, green: 0.58, blue: 0.95)
        ),
        comparisonRows: [PaywallComparisonRow] = MockData.sampleComparisonRows,
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.comparisonRows = comparisonRows
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    public var body: some View {
        ZStack {
            Color.appSystemBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                PaywallHeaderView(
                    delaySeconds: configuration.closeDelaySeconds,
                    tintColor: .primary,
                    onRestore: {
                        Task {
                            if await manager.restorePurchases() {
                                onPurchaseSuccess?()
                            }
                        }
                    },
                    onDismiss: onDismiss
                )
                
                // Top Scrollable Content (Comparison Matrix)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        VStack(spacing: 6) {
                            Text(configuration.appTitle)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text(configuration.appSubtitle)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 2)
                        
                        matrixTableView
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 16)
                }
                
                // Static Bottom Dock (Plans + CTA + Legal Footer)
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
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 12)
                .background(
                    Rectangle()
                        .fill(Color.appSecondaryGroupedBackground)
                        .overlay(
                            Rectangle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Matrix Table
    
    private var matrixTableView: some View {
        VStack(spacing: 0) {
            // Table Header Row
            HStack {
                Text("Capability")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Free")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 70, alignment: .center)
                
                HStack(spacing: 3) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 10))
                    Text("PRO")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                }
                .foregroundColor(configuration.primaryThemeColor)
                .frame(width: 80, alignment: .center)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.appSecondarySystemBackground)
            
            Divider()
            
            // Feature Rows with tap highlight
            ForEach(Array(comparisonRows.enumerated()), id: \.element.id) { index, row in
                let isHovered = hoveredRowId == row.id
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        hoveredRowId = isHovered ? nil : row.id
                    }
                    HapticFeedback.light()
                }) {
                    HStack {
                        Text(row.featureName)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(row.freeTierValue)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.secondary)
                            .frame(width: 70, alignment: .center)
                        
                        HStack(spacing: 3) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(configuration.primaryThemeColor)
                                .font(.system(size: 12))
                                .scaleEffect(isHovered ? 1.2 : 1.0)
                            
                            Text(row.proTierValue)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(configuration.primaryThemeColor)
                        }
                        .frame(width: 80, alignment: .center)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(isHovered ? configuration.primaryThemeColor.opacity(0.1) : (index.isMultiple(of: 2) ? Color.appSystemBackground : Color.appSecondarySystemBackground.opacity(0.4)))
                }
                .buttonStyle(.plain)
                
                if index < comparisonRows.count - 1 {
                    Divider()
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.secondary.opacity(0.18), lineWidth: 1)
        )
    }
    
    // MARK: - Plan Cards (Static Bottom Dock)
    
    private var planSelectionCards: some View {
        HStack(spacing: 10) {
            ForEach(manager.packages.filter { $0.kind == .annual || $0.kind == .monthly }) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(package.kind == .annual ? "Annual" : "Monthly")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if let badge = package.badgeText {
                                DiscountBadgeView(text: badge, backgroundColor: configuration.primaryThemeColor)
                            }
                        }
                        
                        Text(package.localizedPriceString)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(package.weeklyEquivalentString ?? package.periodSubtitle)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.1) : Color.appSystemBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.clear, lineWidth: 2)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - CTA
    
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
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(configuration.primaryThemeColor)
                    .shadow(color: configuration.primaryThemeColor.opacity(0.3), radius: 10, y: 4)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Upgrade to Pro")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 52)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Comparison Matrix Paywall") {
    ComparisonMatrixPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
