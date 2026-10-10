# SwiftUI RevenueCat Paywalls 💎📱

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![iOS 16+](https://img.shields.io/badge/iOS-16.0%2B-blue?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![macOS 13+](https://img.shields.io/badge/macOS-13.0%2B-lightgrey?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![RevenueCat SDK v5+](https://img.shields.io/badge/RevenueCat-v5.0%2B-E5484D?style=flat-square&logo=revenuecat&logoColor=white)](https://www.revenuecat.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)

A curated collection of **designer-grade, high-converting SwiftUI paywalls** built specifically for **RevenueCat**. Plug-and-play with real StoreKit purchasing, instant Xcode Canvas previews, automatic discount calculation, and Apple-style trial timelines.

---

## 🌟 Why This Exists

Most iOS developers face two frustrating choices:
1. **Default `RevenueCatUI` templates**: Generic, repetitive, and cookie-cutter designs that don't match custom brand identities and convert poorly.
2. **Building from scratch**: Re-inventing StoreKit 2 error handling, calculating relative discounts (`"SAVE 68%"` vs monthly), parsing introductory trials, and wiring restore buttons across dozens of views.

**SwiftUI RevenueCat Paywalls** solves this by delivering 7 distinct, battle-tested paywall archetypes engineered for conversion, with a unified `@Observable` state engine and zero-network Xcode preview mock support.

---

## 🎨 7 Unique Paywall Archetypes

```
┌───────────────────────────────────────────────────────────────────────────────────────────────┐
│                               PAYWALL ARCHETYPE CATALOG                                       │
├──────────────────────────────┬─────────────────────────────┬──────────────────────────────────┤
│ Archetype                    │ Best App Niche              │ Conversion & UX Triggers         │
├──────────────────────────────┼─────────────────────────────┼──────────────────────────────────┤
│ 1. Glassmorphic Bento        │ AI, macOS utilities, tools  │ Spatial frosted blur & 2x2 grid  │
│ 2. Apple Timeline Trial      │ Subscriptions & general app │ 3-step trial progress + toggle   │
│ 3. Habit Streak Social Proof │ Fitness, habits, education  │ Gamified ring, milestones & proof│
│ 4. Feature Comparison Matrix │ Scanners, PDF, SaaS tools   │ Free vs Pro sticky check table   │
│ 5. Media Waveform Pulse      │ Audio, music, video apps    │ Dynamic oscillating frequency bar│
│ 6. Cyberpunk Neo-Brutalist   │ Dev tools, crypto, gaming   │ High-contrast neon & tags        │
│ 7. Compact Sheet Modal       │ In-app feature gates        │ Bottom-drawer with 1-tap checkout│
└──────────────────────────────┴─────────────────────────────┴──────────────────────────────────┘
```

### 1. The Glassmorphic Bento (`BentoPaywallView`)
- Spatial glass aesthetic inspired by visionOS.
- 2x2 interactive Bento grid highlighting premium capabilities with micro-interaction badges.
- Horizontal plan selector cards with dynamic discount tags and weekly breakdown (`"$0.77 / week"`).

### 2. The Apple Timeline Trial (`TimelineTrialPaywallView`)
- **The #1 highest-converting layout in top-grossing apps**.
- Interactive 3-step visual timeline:
  - `Today`: Instant access, $0.00 charged.
  - `Day 5`: Friendly reminder notification.
  - `Day 7`: Annual billing starts.
- "Enable Free Trial" toggle and risk-free guarantee disclaimer.

### 3. The Habit & Streak Social Proof (`HabitStreakPaywallView`)
- Gamified streak flame ring (`"Join 48,000+ members"`).
- Milestone roadmap: `Day 1 (Kickoff)` $\to$ `Day 14 (Lock-In)` $\to$ `Day 30 (Mastery)`.
- Verified App Store testimonial quotes and warm high-energy colors.

### 4. The Feature Comparison Matrix (`ComparisonMatrixPaywallView`)
- Clean Free vs Pro side-by-side comparison table.
- Clear checkmarks and value indicators for unlocked tiers.
- Quick Annual vs Monthly toggle pill with `"SAVE 68%"` ribbon.

### 5. The Waveform / Media Pulse (`MediaWaveformPaywallView`)
- Real-time animated audio visualizer spectrum that pulses and breathes.
- Dark studio aesthetic with cyan and electric violet neon glow.
- Studio master-track plan cards tailored for creative & audio apps.

### 6. The Cyberpunk Neo-Brutalist (`CyberpunkPaywallView`)
- High-contrast neon green (`#10B981`) and hot pink borders.
- Monospaced tags (`[SYSTEM: READY_FOR_UPGRADE]`, `> EXECUTE_UPGRADE`).
- Bold brutalist drop-shadows tailored for developer utilities, crypto, and terminal apps.

### 7. The Compact Sheet Modal (`CompactSheetPaywallView`)
- Designed as a bottom drawer / half-sheet for gated features (e.g., export limit hit).
- Biometric lock shield icon animation.
- Fast 1-tap Apple Pay style checkout button.

---

## ⚡ Quick Start

### 1. Add Swift Package
In Xcode: **File** $\to$ **Add Package Dependencies...**
```
https://github.com/nilkanthdesai76/swiftui-revenuecat-paywalls
```

### 2. Present Any Paywall in 3 Lines of Code

```swift
import SwiftUI
import RevenueCatPaywalls

struct ContentView: View {
    @State private var showPaywall = false
    @StateObject private var paywallManager = PaywallManager()
    
    var body: some View {
        Button("Upgrade to Pro") {
            showPaywall = true
        }
        .sheet(isPresented: $showPaywall) {
            BentoPaywallView(
                manager: paywallManager,
                onDismiss: { showPaywall = false },
                onPurchaseSuccess: {
                    showPaywall = false
                    print("User upgraded!")
                }
            )
        }
        .task {
            // Automatically fetches live RevenueCat packages:
            await paywallManager.loadOfferings()
        }
    }
}
```

---

## 🛠️ Offline & Xcode Canvas Previews

No RevenueCat account or API key needed to test and iterate on designs! Pass `isMockMode: true` to test all package selections, trial toggles, purchase simulations, and restore flows right in the Xcode canvas:

```swift
#Preview {
    TimelineTrialPaywallView(
        manager: PaywallManager(isMockMode: true),
        onDismiss: {}
    )
}
```

---

## 📱 Running the Interactive Showcase App

A complete iOS showcase catalog application is included in `PaywallShowcase`:

1. Open `PaywallShowcase/PaywallShowcase.xcodeproj` in Xcode.
2. Select any iOS Simulator (e.g. **iPhone 17 Pro** or **iPhone 18 Pro**).
3. Press **`Cmd + R`** to run.
4. Browse and tap through all 7 paywalls, test real-time trial switches, haptic responses, and toggle between Mock Mode and Live RevenueCat API Key mode!

---

## 🧪 Architecture & State Management

```
┌────────────────────────────────────────────────────────┐
│                   RevenueCatPaywalls                   │
├────────────────────────────────────────────────────────┤
│  PaywallManager (@MainActor, ObservableObject)         │
│  ├── packages: [PaywallPackage]                        │
│  ├── selectedPackage: PaywallPackage?                  │
│  ├── isFreeTrialEnabled: Bool                          │
│  ├── isLoading / isPurchasing / isRestoring: Bool      │
│  ├── purchaseSelected() async -> Bool                  │
│  └── restorePurchases() async -> Bool                  │
├────────────────────────────────────────────────────────┤
│  PricingCalculator                                     │
│  ├── processPackages([Package]) -> [PaywallPackage]    │
│  ├── Annual vs Monthly discount calculation            │
│  └── Weekly breakdown ($Price / 52)                    │
└────────────────────────────────────────────────────────┘
```

---

## 📄 License

MIT License. Designed and crafted with care by [Nilkanth Desai](https://github.com/nilkanthdesai76).
