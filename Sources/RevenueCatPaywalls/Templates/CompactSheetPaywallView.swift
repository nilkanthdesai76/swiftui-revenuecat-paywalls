import SwiftUI

public struct CompactSheetPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var isUnlocked: Bool = false
    @State private var lockScale: CGFloat = 0.9
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Unlock Full Access",
            appSubtitle: "Continue using all premium features without restrictions",
            appIconSystemName: "lock.shield.fill",
            primaryThemeColor: Color(red: 0.18, green: 0.65, blue: 0.45)
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
        VStack(spacing: 0) {
            // Drag Indicator & Close Bar
            VStack(spacing: 6) {
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        HapticFeedback.light()
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.secondary)
                            .frame(width: 30, height: 30)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Top Scrollable Content (Icon & Feature highlights)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Animated Unlocking Shield
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(configuration.primaryThemeColor.opacity(0.15))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(configuration.primaryThemeColor)
                                .scaleEffect(lockScale)
                        }
                        
                        Text(configuration.appTitle)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(configuration.appSubtitle)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    
                    // Quick bullets
                    VStack(alignment: .leading, spacing: 10) {
                        bulletItem(icon: "bolt.fill", title: "Instant Unlimited Exports", desc: "No daily throttles or file limits")
                        bulletItem(icon: "icloud.fill", title: "Encrypted Cloud Sync", desc: "Synchronized across all your devices")
                        bulletItem(icon: "nosign", title: "100% Ad-Free Forever", desc: "Clean distraction-free workflow")
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.appSecondarySystemBackground)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            
            // Static Bottom Dock (Plans + 1-Tap CTA + Legal Footer)
            VStack(spacing: 12) {
                planSelectionCards
                ctaButton
                
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
            .padding(.top, 12)
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
        .background(Color.appSystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isUnlocked = true
                    lockScale = 1.15
                }
                HapticFeedback.light()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.spring()) {
                        lockScale = 1.0
                    }
                }
            }
        }
        .alert("Notice", isPresented: $manager.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(manager.errorMessage ?? "An error occurred.")
        }
    }
    
    private func bulletItem(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(configuration.primaryThemeColor)
                .font(.system(size: 14, weight: .bold))
                .frame(width: 22)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                Text(desc)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    // MARK: - Plan Selection Cards
    
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
                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .secondary.opacity(0.35))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    Text(badge)
                                        .font(.system(size: 9, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(configuration.primaryThemeColor, in: Capsule())
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
                                    .foregroundColor(configuration.primaryThemeColor)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(package.localizedPriceString)
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(isSelected ? configuration.primaryThemeColor : .primary)
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
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.1) : Color.appSystemBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.secondary.opacity(0.12), lineWidth: isSelected ? 2 : 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - CTA
    
    private var ctaButton: some View {
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
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Continue")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 48)
        }
        .disabled(manager.isPurchasing)
    }
}

// MARK: - Canvas Preview

#Preview("Compact Sheet Paywall") {
    CompactSheetPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
