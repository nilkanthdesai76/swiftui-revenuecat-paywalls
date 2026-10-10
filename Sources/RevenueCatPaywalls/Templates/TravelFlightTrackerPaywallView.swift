import SwiftUI
import RevenueCat

public struct TravelFlightTrackerPaywallView: View {
    @ObservedObject public var manager: PaywallManager
    public var configuration: PaywallConfiguration
    public var onDismiss: () -> Void
    public var onPurchaseSuccess: (() -> Void)?
    
    @State private var planeProgress: CGFloat = 0.65
    @State private var radarPulse: CGFloat = 1.0
    
    public init(
        manager: PaywallManager,
        configuration: PaywallConfiguration = PaywallConfiguration(
            appTitle: "Flight Radar & Travel Pass",
            appSubtitle: "Live satellite ADS-B tracking, gate change alerts, and baggage carousel notifications.",
            primaryThemeColor: Color(red: 0.10, green: 0.60, blue: 0.98),
            secondaryThemeColor: Color(red: 0.98, green: 0.65, blue: 0.15)
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
            Color(red: 0.05, green: 0.08, blue: 0.12)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Top Scrollable Boarding Pass & Features
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        boardingPassCard
                        headlineSection
                        flightLiveStats
                        travelProFeatures
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                // Static Bottom Dock (Plans + Flight CTA + Legal Footer)
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
                        .fill(Color(red: 0.08, green: 0.11, blue: 0.16).opacity(0.96))
                        .overlay(
                            Rectangle()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 1),
                            alignment: .top
                        )
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                radarPulse = 1.15
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
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(configuration.secondaryThemeColor)
                Text("GLOBAL RADAR PRO")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .overlay(Capsule().stroke(configuration.primaryThemeColor.opacity(0.4), lineWidth: 1))
            )
            
            Spacer()
            
            Button {
                Task {
                    if await manager.restorePurchases() {
                        onPurchaseSuccess?()
                    }
                }
            } label: {
                Text("Restore")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }
    
    // MARK: - Boarding Pass Card
    private var boardingPassCard: some View {
        VStack(spacing: 0) {
            // Upper Pass
            VStack(spacing: 12) {
                HStack {
                    Label("BRITISH AIRWAYS • BA 178", systemImage: "airplane")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(configuration.primaryThemeColor)
                    Spacer()
                    Text("ON TIME • +18m EARLY")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.green.opacity(0.15)))
                }
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("JFK")
                            .font(.system(size: 28, weight: .heavy, design: .monospaced))
                            .foregroundColor(.white)
                        Text("New York")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "airplane")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(configuration.secondaryThemeColor)
                        Text("07h 05m")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("LHR")
                            .font(.system(size: 28, weight: .heavy, design: .monospaced))
                            .foregroundColor(.white)
                        Text("London Heathrow")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                // Flight Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .frame(height: 4)
                        
                        Capsule()
                            .fill(configuration.primaryThemeColor)
                            .frame(width: geo.size.width * planeProgress, height: 4)
                        
                        Circle()
                            .fill(configuration.secondaryThemeColor)
                            .frame(width: 10, height: 10)
                            .offset(x: (geo.size.width * planeProgress) - 5)
                    }
                }
                .frame(height: 10)
            }
            .padding(16)
            .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            // Perforated Divider
            HStack(spacing: 4) {
                ForEach(0..<24, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 8, height: 2)
                    Spacer(minLength: 2)
                }
            }
            .padding(.vertical, 2)
            .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            // Lower Pass Details
            HStack {
                detailItem(label: "GATE", value: "A14")
                Spacer()
                detailItem(label: "SEAT", value: "2A")
                Spacer()
                detailItem(label: "CAROUSEL", value: "B04")
                Spacer()
                detailItem(label: "TAIL", value: "G-ZBKB")
            }
            .padding(14)
            .background(Color(red: 0.10, green: 0.13, blue: 0.19))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(configuration.primaryThemeColor.opacity(0.35), lineWidth: 1)
        )
    }
    
    private func detailItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Headline
    private var headlineSection: some View {
        VStack(spacing: 8) {
            Text(configuration.appTitle)
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(configuration.appSubtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    // MARK: - Flight Live Stats
    private var flightLiveStats: some View {
        HStack(spacing: 10) {
            liveStatChip(icon: "gauge.with.needle.fill", title: "ALTITUDE", val: "38,000 FT")
            liveStatChip(icon: "speedometer", title: "GROUND SPEED", val: "542 KTS")
            liveStatChip(icon: "wind", title: "TAILWIND", val: "+64 MPH")
        }
    }
    
    private func liveStatChip(icon: String, title: String, val: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(configuration.secondaryThemeColor)
            Text(title)
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
            Text(val)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.06), lineWidth: 1))
        )
    }
    
    // MARK: - Travel Features
    private var travelProFeatures: some View {
        VStack(spacing: 10) {
            travelRow(icon: "bell.badge.fill", title: "Instant Gate & Delay Push Alerts", desc: "Know your new gate and baggage belt 20 minutes before airport monitors.")
            travelRow(icon: "airplane.arrival", title: "Inbound Aircraft History", desc: "Track where your incoming plane is arriving from to anticipate delays.")
            travelRow(icon: "map.fill", title: "Live 3D Satellite Flight Radar", desc: "Smooth 60fps flight route radar with oceanic tracks and live weather overlay.")
            travelRow(icon: "calendar.badge.clock", title: "Auto Calendar & Trip Sync", desc: "Seamless integration with Apple Calendar, TripIt, and Lock Screen Live Activities.")
        }
    }
    
    private func travelRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(configuration.primaryThemeColor)
                .frame(width: 32, height: 32)
                .background(Circle().fill(configuration.primaryThemeColor.opacity(0.18)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                Text(desc)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06), lineWidth: 1))
        )
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
                        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(isSelected ? configuration.primaryThemeColor : .white.opacity(0.35))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(package.title)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                
                                if let badge = package.badgeText {
                                    DiscountBadgeView(
                                        text: badge,
                                        backgroundColor: configuration.primaryThemeColor,
                                        textColor: .white
                                    )
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
                                .font(.system(size: 15, weight: .heavy))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                            
                            Text(package.periodSubtitle)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.white.opacity(0.55))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isSelected ? configuration.primaryThemeColor.opacity(0.18) : Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(isSelected ? configuration.primaryThemeColor : Color.white.opacity(0.08), lineWidth: isSelected ? 1.5 : 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - CTA Button
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
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [configuration.primaryThemeColor, configuration.secondaryThemeColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: configuration.primaryThemeColor.opacity(0.35), radius: 8, y: 4)
                
                if manager.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "airplane.circle.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text(manager.selectedPackage?.hasFreeTrial == true ? "Start 7-Day Free Trial" : "Track All Flights Live")
                            .font(.system(size: 15, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .disabled(manager.isPurchasing || manager.selectedPackage == nil)
    }
}


#if DEBUG
#Preview {
    TravelFlightTrackerPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
#endif
