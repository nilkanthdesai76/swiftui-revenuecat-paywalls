import SwiftUI

public struct AIPromptTokensMeterPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var quotaProgress: Double = 1.0 // 100% depleted
    @State private var pulseGlow: CGFloat = 1.0
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Unlimited AI Intelligence",
            appSubtitle: "Supercharge your workflow with uncapped GPT-4o, Claude 3.5, and reasoning models.",
            primaryThemeColor: Color(red: 0.55, green: 0.35, blue: 0.98),
            secondaryThemeColor: Color(red: 0.10, green: 0.85, blue: 0.75)
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
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable AI Token Canvas
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        quotaDepletedBanner
                        headlineSection
                        aiModelPillGrid
                        aiProCapabilities
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + AI CTA + Legal Footer)
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
                        .fill(Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.95))
                        .overlay(
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseGlow = 1.2
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
            HStack(spacing: 6) {
                Image(systemName: "cpu.fill")
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("NEURAL TURBO")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.08), in: Capsule())
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(8)
                    .background(Color.white.opacity(0.12), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    // MARK: - Quota Depleted Banner
    
    private var quotaDepletedBanner: some View {
        VStack(spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                    Text("Daily Free Tokens: 5/5 Used")
                        .font(.system(size: 12.5, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("DEPLETED")
                    .font(.system(size: 9.5, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color(red: 1.0, green: 0.3, blue: 0.2), in: Capsule())
            }
            
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(Color(red: 1.0, green: 0.4, blue: 0.2))
                        .frame(width: geo.size.width * quotaProgress, height: 8)
                }
            }
            .frame(height: 8)
            
            Text("Free tier reset in 18 hours. Upgrade to unlock infinite queries with no wait times.")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.65))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Headline
    
    private var headlineSection: some View {
        VStack(spacing: 6) {
            Text(configuration.appTitle)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Model Pills
    
    private var aiModelPillGrid: some View {
        HStack(spacing: 8) {
            modelBadge("GPT-4o")
            modelBadge("Claude 3.5 Sonnet")
            modelBadge("DeepSeek V3")
        }
    }
    
    private func modelBadge(_ name: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(configuration.secondaryThemeColor)
                .frame(width: 6, height: 6)
            Text(name)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.08), in: Capsule())
    }
    
    // MARK: - Pro Capabilities
    
    private var aiProCapabilities: some View {
        VStack(spacing: 10) {
            aiRow(icon: "bolt.fill", title: "Zero Wait Queue & 100x Speed", desc: "Dedicated high-priority compute cluster with instant token generation.")
            aiRow(icon: "doc.text.magnifyingglass", title: "200k Context Window & Files", desc: "Analyze full PDFs, code repos, and audio transcripts without truncation.")
            aiRow(icon: "sparkles.rectangle.stack", title: "Photorealistic Image Generation", desc: "Create high-resolution studio visuals with Flux Pro and DALL-E 3.")
        }
    }
    
    private func aiRow(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(configuration.primaryThemeColor.opacity(0.25))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(desc)
                    .font(.system(size: 11.5, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.04))
        )
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
                            .foregroundColor(isSelected ? configuration.secondaryThemeColor : .white.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    Text(badge)
                                        .font(.system(size: 9, weight: .black, design: .rounded))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(configuration.secondaryThemeColor, in: Capsule())
                                        .lineLimit(1)
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.white.opacity(0.65))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            } else if let trial = package.introTrialText {
                                Text(trial)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color.green)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(isSelected ? configuration.secondaryThemeColor : .white)
                                .lineLimit(1)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.white.opacity(0.55))
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.18) : Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? configuration.secondaryThemeColor : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
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
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.4), radius: 12, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Unlock Infinite AI Tokens")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 52)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("AI Prompt Tokens Meter Paywall") {
    AIPromptTokensMeterPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
