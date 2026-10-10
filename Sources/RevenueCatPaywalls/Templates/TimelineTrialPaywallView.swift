import SwiftUI

public struct TimelineTrialPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var timelineSteps: [TrialTimelineStep]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var nodePulse: Bool = false
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Try Pro Risk-Free",
            appSubtitle: "Experience the full toolkit free for 7 days. Zero commitment.",
            appIconSystemName: "shield.lefthalf.filled",
            primaryThemeColor: Color(red: 0.16, green: 0.50, blue: 0.98)
        ),
        timelineSteps: [TrialTimelineStep] = MockData.sampleTimelineSteps,
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.timelineSteps = timelineSteps
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    public var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 0) {
                // Top Header
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
                
                // Top Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerSection
                        
                        // Interactive Timeline with pulsing nodes
                        TrialTimelineView(
                            steps: timelineSteps,
                            accentColor: configuration.primaryThemeColor
                        )
                        .scaleEffect(nodePulse ? 1.01 : 1.0)
                        
                        reassuranceFooter
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                
                // Static Sticky Bottom Dock
                VStack(spacing: 12) {
                    trialToggleCard
                    planSummaryCard
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
                                .fill(Color.secondary.opacity(0.15))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                nodePulse = true
            }
        }
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Background
    
    private var backgroundView: some View {
        Color.appSystemGroupedBackground
            .ignoresSafeArea()
            .overlay(
                RadialGradient(
                    colors: [configuration.primaryThemeColor.opacity(0.12), Color.clear],
                    center: .top,
                    startRadius: 0,
                    endRadius: 400
                )
                .ignoresSafeArea()
            )
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: configuration.appIconSystemName)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(configuration.primaryThemeColor)
                .padding(.top, 4)
            
            Text(configuration.appTitle)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Trial Toggle Card
    
    private var trialToggleCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Enable 7-Day Free Trial")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(manager.isFreeTrialEnabled ? "You won't be charged anything today" : "Instant discount applied directly")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { manager.isFreeTrialEnabled },
                set: { manager.toggleFreeTrial(enabled: $0) }
            ))
            .labelsHidden()
            .tint(configuration.primaryThemeColor)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.appSystemBackground)
                .shadow(color: Color.black.opacity(0.03), radius: 6, y: 2)
        )
    }
    
    // MARK: - Plan Summary
    
    private var planSummaryCard: some View {
        Group {
            if let package = manager.selectedPackage {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(package.title)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            if let badge = package.badgeText {
                                DiscountBadgeView(text: badge, backgroundColor: configuration.primaryThemeColor)
                            }
                        }
                        
                        if let weekly = package.weeklyEquivalentString {
                            Text(weekly)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(package.localizedPriceString)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(package.periodSubtitle)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.appSystemBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(configuration.primaryThemeColor.opacity(0.35), lineWidth: 1.5)
                        )
                )
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
                    .shadow(color: configuration.primaryThemeColor.opacity(0.35), radius: 10, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    Text(manager.isFreeTrialEnabled ? "Start 7-Day Free Trial" : "Continue to Payment")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 52)
        }
        .disabled(manager.isPurchasing)
    }
    
    // MARK: - Reassurance
    
    private var reassuranceFooter: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.shield.fill")
                .foregroundColor(.green)
                .font(.system(size: 14))
            
            Text("No commitment • Cancel in 2 taps via Apple Settings")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Canvas Preview

#Preview("Apple Timeline Trial Paywall") {
    TimelineTrialPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
