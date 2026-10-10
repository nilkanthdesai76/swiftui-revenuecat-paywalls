import SwiftUI

public struct SpatialImmersivePaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var auroraOffset: CGFloat = 0
    @State private var orbScale: CGFloat = 1.0
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Spatial Intelligence Pro",
            appSubtitle: "Next-generation spatial models, zero latency, and limitless computing.",
            primaryThemeColor: Color(red: 0.40, green: 0.20, blue: 0.95),
            secondaryThemeColor: Color(red: 0.15, green: 0.85, blue: 0.95)
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
            // Immersive Deep Space Ambient Background
            Color(red: 0.04, green: 0.04, blue: 0.08)
                .ignoresSafeArea()
            
            auroraBackground
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Spatial Canvas
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        heroSpatialBadge
                        headlineSection
                        spatialFeatureTiles
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Spatial CTA + Legal Footer)
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
                        .fill(Color(red: 0.07, green: 0.07, blue: 0.12).opacity(0.85))
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
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                auroraOffset = 40
                orbScale = 1.15
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
    
    // MARK: - Ambient Aurora
    
    private var auroraBackground: some View {
        ZStack {
            Circle()
                .fill(configuration.primaryThemeColor.opacity(0.35))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -80 + auroraOffset, y: -160)
            
            Circle()
                .fill(configuration.secondaryThemeColor.opacity(0.3))
                .frame(width: 280, height: 280)
                .blur(radius: 75)
                .offset(x: 100 - auroraOffset, y: -60)
                .scaleEffect(orbScale)
        }
        .allowsHitTesting(false)
    }
    
    // MARK: - Header
    
    private var headerBar: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(configuration.secondaryThemeColor)
                    .frame(width: 7, height: 7)
                    .shimmering(duration: 1.5)
                
                Text("SPATIAL OS")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
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
                    .background(Color.white.opacity(0.1), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    // MARK: - Hero Badge
    
    private var heroSpatialBadge: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 76, height: 76)
                .shadow(color: configuration.primaryThemeColor.opacity(0.5), radius: 20, y: 6)
            
            Image(systemName: "cube.transparent.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.top, 6)
    }
    
    // MARK: - Headline
    
    private var headlineSection: some View {
        VStack(spacing: 8) {
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
    
    // MARK: - Feature Tiles
    
    private var spatialFeatureTiles: some View {
        VStack(spacing: 10) {
            spatialCard(icon: "sparkles", title: "Ultra Real-Time Inference", desc: "Zero compute queue with dedicated neural GPU allocations.")
            spatialCard(icon: "visionpro", title: "Spatial Multi-Window Sync", desc: "Fluid cross-device spatial canvas persistence in 60fps.")
            spatialCard(icon: "infinity", title: "Unbounded Processing Workspaces", desc: "No session cutoffs or file size boundaries.")
        }
    }
    
    private func spatialCard(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(desc)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
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
                                    .foregroundColor(configuration.secondaryThemeColor)
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
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.2) : Color.white.opacity(0.04))
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
                    .shadow(color: configuration.primaryThemeColor.opacity(0.5), radius: 14, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Unlock Spatial Studio")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 15))
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

#Preview("Spatial Immersive Paywall") {
    SpatialImmersivePaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
