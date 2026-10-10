import SwiftUI

public struct MinimalistEditorialPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "The Master Collection",
            appSubtitle: "Curated tools, unrestricted focus, and timeless design.",
            primaryThemeColor: Color(red: 0.12, green: 0.12, blue: 0.14),
            secondaryThemeColor: Color(red: 0.85, green: 0.72, blue: 0.52)
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
            Color.appSystemBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Editorial Section
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        heroHeadlineSection
                        editorialQuoteSection
                        benefitsListSection
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Membership CTA + Legal Footer)
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
                        .fill(Color.appSecondaryGroupedBackground)
                        .overlay(
                            Rectangle()
                                .fill(Color.secondary.opacity(0.12))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
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
            Text("EDITION № 01")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color.secondary.opacity(0.12), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    // MARK: - Hero Headline
    
    private var heroHeadlineSection: some View {
        VStack(spacing: 10) {
            Text("MEMBER ACCESS")
                .font(.system(size: 11, weight: .black, design: .rounded))
                .tracking(2.5)
                .foregroundColor(configuration.secondaryThemeColor)
            
            Text(configuration.appTitle)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Editorial Quote
    
    private var editorialQuoteSection: some View {
        VStack(spacing: 8) {
            Text("\"Simplicity is the ultimate sophistication.\"")
                .font(.system(size: 15, weight: .medium, design: .serif))
                .italic()
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("— FEATURED IN EDITORIAL DESIGN DIGEST")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.appSecondarySystemBackground)
        )
    }
    
    // MARK: - Benefits List
    
    private var benefitsListSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            benefitRow(num: "01", title: "Complete Archive Access", desc: "Unlock all past, present, and future editions with no restrictions.")
            benefitRow(num: "02", title: "Pure Distraction-Free Space", desc: "Zero telemetry tracking, no ads, and no external interruptions.")
            benefitRow(num: "03", title: "Lossless Export & Typography", desc: "Publish with curated bespoke typefaces and studio-grade resolution.")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appSecondarySystemBackground.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
                )
        )
    }
    
    private func benefitRow(num: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(num)
                .font(.system(size: 14, weight: .bold, design: .serif))
                .foregroundColor(configuration.secondaryThemeColor)
                .frame(width: 24, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .serif))
                    .foregroundColor(.primary)
                
                Text(desc)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    // MARK: - Plans (Static Bottom Dock)
    
    private var planSelectionCards: some View {
        VStack(spacing: 8) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(isSelected ? .primary : .secondary.opacity(0.35))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 14, weight: .bold, design: .serif))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    Text(badge)
                                        .font(.system(size: 8.5, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(configuration.secondaryThemeColor, in: Capsule())
                                        .lineLimit(1)
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            } else if let trial = package.introTrialText {
                                Text(trial)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(configuration.secondaryThemeColor)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isSelected ? configuration.secondaryThemeColor.opacity(0.12) : Color.appSystemBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(isSelected ? Color.primary : Color.secondary.opacity(0.12), lineWidth: isSelected ? 1.5 : 1)
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
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.primary)
                
                if manager.isPurchasing {
                    ProgressView().tint(Color.appSystemBackground)
                } else {
                    HStack(spacing: 8) {
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Begin Membership")
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .foregroundColor(Color.appSystemBackground)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.appSystemBackground)
                    }
                }
            }
            .frame(height: 52)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Minimalist Editorial Paywall") {
    MinimalistEditorialPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
