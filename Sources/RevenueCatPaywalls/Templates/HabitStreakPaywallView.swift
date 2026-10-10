import SwiftUI

public struct HabitStreakPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var features: [PaywallFeatureItem]
    public var testimonials: [PaywallTestimonial]
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Unlock Your Best Self",
            appSubtitle: "Build life-changing routines and never break the chain",
            appIconSystemName: "flame.fill",
            primaryThemeColor: Color(red: 0.94, green: 0.35, blue: 0.20),
            secondaryThemeColor: Color(red: 0.98, green: 0.65, blue: 0.22)
        ),
        features: [PaywallFeatureItem] = MockData.sampleHabitFeatures,
        testimonials: [PaywallTestimonial] = MockData.sampleTestimonials,
        onDismiss: @escaping () -> Void,
        onPurchaseSuccess: (() -> Void)? = nil
    ) {
        self.manager = manager
        self.configuration = configuration
        self.features = features
        self.testimonials = testimonials
        self.onDismiss = onDismiss
        self.onPurchaseSuccess = onPurchaseSuccess
    }
    
    public var body: some View {
        ZStack {
            // Warm gradient background
            backgroundView
            
            VStack(spacing: 0) {
                // Top header
                PaywallHeaderView(
                    delaySeconds: configuration.closeDelaySeconds,
                    tintColor: .white,
                    onRestore: {
                        Task {
                            if await manager.restorePurchases() {
                                onPurchaseSuccess?()
                            }
                        }
                    },
                    onDismiss: onDismiss
                )
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        // Gamified Streak Hero
                        streakHeroVisual
                        
                        // Milestone Roadmap
                        milestoneRoadmapSection
                        
                        // Feature List
                        featuresSection
                        
                        // Testimonial Spotlight
                        testimonialCard
                        
                        // Plan Selector
                        planSelectorSection
                        
                        // CTA
                        ctaButtonSection
                        
                        // Legal Footer
                        PaywallLegalFooterView(
                            termsURL: configuration.termsURL,
                            privacyURL: configuration.privacyURL,
                            textColor: .white.opacity(0.6),
                            onRestore: {
                                Task {
                                    if await manager.restorePurchases() {
                                        onPurchaseSuccess?()
                                    }
                                }
                            }
                        )
                        .padding(.top, 4)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .preferredColorScheme(.dark)
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Background
    
    private var backgroundView: some View {
        Color(red: 0.08, green: 0.08, blue: 0.10)
            .ignoresSafeArea()
            .overlay(
                RadialGradient(
                    colors: [configuration.primaryThemeColor.opacity(0.25), Color.clear],
                    center: .top,
                    startRadius: 0,
                    endRadius: 360
                )
                .ignoresSafeArea()
            )
    }
    
    // MARK: - Streak Hero
    
    private var streakHeroVisual: some View {
        VStack(spacing: 12) {
            ZStack {
                // Outer animated flame ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 84, height: 84)
                    .shadow(color: configuration.primaryThemeColor.opacity(0.6), radius: 14)
                
                VStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 30))
                        .foregroundColor(configuration.secondaryThemeColor)
                    
                    Text("30 DAYS")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 4)
            
            Text(configuration.appTitle)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 11))
                Text("Joined by 48,000+ active habit builders")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // MARK: - Milestone Roadmap
    
    private var milestoneRoadmapSection: some View {
        HStack(spacing: 8) {
            milestonePill(day: "Day 1", label: "Kickoff", icon: "sparkles", done: true)
            milestoneDivider
            milestonePill(day: "Day 14", label: "Lock-In", icon: "brain.head.profile", done: true)
            milestoneDivider
            milestonePill(day: "Day 30", label: "Mastery", icon: "trophy.fill", done: false)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func milestonePill(day: String, label: String, icon: String, done: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(done ? configuration.secondaryThemeColor : .white.opacity(0.4))
            
            Text(day)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var milestoneDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(width: 1, height: 28)
    }
    
    // MARK: - Features
    
    private var featuresSection: some View {
        VStack(spacing: 12) {
            ForEach(features) { item in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(configuration.primaryThemeColor.opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: item.icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(configuration.secondaryThemeColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(item.subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.65))
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Testimonial
    
    private var testimonialCard: some View {
        Group {
            if let first = testimonials.first {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 3) {
                        ForEach(0..<first.stars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.yellow)
                        }
                        
                        Spacer()
                        
                        Text("Verified Subscriber")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Text("\"\(first.comment)\"")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                        .italic()
                    
                    Text("— \(first.authorName)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                )
            }
        }
    }
    
    // MARK: - Plans
    
    private var planSelectorSection: some View {
        VStack(spacing: 10) {
            ForEach(manager.packages) { package in
                let isSelected = manager.selectedPackage?.id == package.id
                
                Button(action: {
                    manager.selectPackage(package)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSelected ? configuration.secondaryThemeColor : .white.opacity(0.3))
                            .font(.system(size: 18))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                if let badge = package.badgeText {
                                    DiscountBadgeView(text: badge, backgroundColor: configuration.primaryThemeColor)
                                }
                            }
                            
                            if let weekly = package.weeklyEquivalentString {
                                Text(weekly)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isSelected ? Color.white.opacity(0.10) : Color.white.opacity(0.03))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(isSelected ? configuration.secondaryThemeColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
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
                    .shadow(color: configuration.primaryThemeColor.opacity(0.5), radius: 12, y: 5)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Commit to My Goals")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 54)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Habit Streak Paywall") {
    HabitStreakPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
