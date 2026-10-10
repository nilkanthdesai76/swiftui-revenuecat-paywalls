# SwiftUI RevenueCat Paywalls 💎📱

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![iOS 16+](https://img.shields.io/badge/iOS-16.0%2B-blue?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![macOS 13+](https://img.shields.io/badge/macOS-13.0%2B-lightgrey?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![RevenueCat SDK v5+](https://img.shields.io/badge/RevenueCat-v5.0%2B-E5484D?style=flat-square&logo=revenuecat&logoColor=white)](https://www.revenuecat.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)

A curated collection of **40 production-grade, high-converting SwiftUI paywalls** built specifically for **RevenueCat**. Plug-and-play with real StoreKit purchasing, stationary pinned bottom docks, zero text clipping, instant Xcode Canvas previews, automatic discount calculation, interactive micro-animations, and exit-intent downsell offers.

---

## 🌟 Why This Exists

Most iOS developers face two frustrating choices:
1. **Default `RevenueCatUI` templates**: Generic, repetitive, and cookie-cutter designs that don't match custom brand identities and convert poorly.
2. **Building from scratch**: Re-inventing StoreKit 2 error handling, calculating relative discounts (`"SAVE 68%"` vs monthly), parsing introductory trials, designing interactive gestures, and wiring restore buttons across dozens of views.

**SwiftUI RevenueCat Paywalls** solves this by delivering **40 distinct, battle-tested paywall templates** covering every major app niche and monetization strategy — engineered for maximum conversion with a unified `@MainActor` state engine and zero-network Xcode preview mock support.

---

## 🎨 40 Comprehensive Paywall Templates

### 📱 General Archetypes (23 Templates)
1. **Glassmorphic Bento** (`BentoPaywallView`): Spatial frosted glass tiles, 2x2 bento grid, and micro-interaction badges.
2. **Apple Timeline Trial** (`TimelineTrialPaywallView`): Top-grossing 3-step trial timeline (Today $\to$ Day 5 $\to$ Day 7) with interactive trial toggle switch.
3. **Habit Streak & Social Proof** (`HabitStreakPaywallView`): Gamified streak flame rings, 30-day milestone roadmap, and 48,000+ member proof.
4. **Feature Comparison Matrix** (`ComparisonMatrixPaywallView`): Clean Free vs Pro side-by-side comparison table with sticky checkmarks.
5. **Media Waveform & Pulse** (`MediaWaveformPaywallView`): Animated audio visualizer frequency bars for music, pod, and studio apps.
6. **Cyberpunk Neo-Brutalist** (`CyberpunkPaywallView`): High-contrast neon green/pink borders, terminal cursor, and developer tech tags.
7. **Compact Sheet Modal** (`CompactSheetPaywallView`): Bottom drawer with biometric lock shield unlock animation and 1-tap checkout.
8. **Minimalist Editorial** (`MinimalistEditorialPaywallView`): Luxury serif typography, warm paper tones, and clean magazine quote styling.
9. **Spatial Immersive** (`SpatialImmersivePaywallView`): visionOS ambient aurora gradients, 3D depth, and floating holographic tiles.
10. **Before/After Drag Slider** (`BeforeAfterSliderPaywallView`): Interactive split-screen comparison slider showcasing raw vs pro output.
11. **Video Hero Cinematic** (`VideoHeroCinematicPaywallView`): Hollywood 4K ProRes dark aesthetic with tech specs and studio master reel.
12. **Fitness Rings Metrics** (`FitnessRingsMetricsPaywallView`): Apple Watch concentric activity rings and personalized daily calorie targets.
13. **Quiz Results Personalized** (`QuizResultsPersonalizedPaywallView`): Onboarding quiz trajectory roadmap with 94% algorithm success score.
14. **Finance Wealth Clean** (`FinanceWealthCleanPaywallView`): Bloomberg & Copilot wealth growth simulator with AES-256 bank encryption.
15. **Social Proof Wall** (`SocialProofWallPaywallView`): 4.9-star ratings banner and verified App Store subscriber testimonials.
16. **AI Prompt Quota & Models** (`AIPromptTokensMeterPaywallView`): Live quota depletion meter, model badges (GPT-4o, Claude 3.5), and speed indicators.
17. **Scanner & PDF OCR Studio** (`DocumentScannerPDFPaywallView`): Moving cyan laser beam scanner, real-time OCR text highlight, and PDF vault.
18. **VPN & Privacy UltraShield** (`VPNSecurityShieldPaywallView`): 3D cybersecurity shield with animated ping radar & 90+ global server nodes.
19. **Meditation & Sleep Soundscape** (`MeditationSleepSoundscapePaywallView`): Twilight night sky with animated breathing circle & interactive sound mixer.
20. **Language & Polyglot Mastery** (`LanguageVocabMasteryPaywallView`): 3D vocabulary flashcard flip, CEFR fluency ladder (A1-C2), and AI accent coach.
21. **Flight Radar & Travel Pass** (`TravelFlightTrackerPaywallView`): Perforated boarding pass (JFK-LHR), flight progress bar, and altitude telemetry.
22. **Retro Arcade Game Pass** (`RetroArcadeGamingPaywallView`): 8-bit CRT arcade scanlines, blinking INSERT COIN credit, and 60 FPS rewind.
23. **Master Audio & Podcast Suite** (`PodcastAudiobookPlayerPaywallView`): Rotating vinyl record player, word-by-word AI transcripts, and silence trimmer.

### 🎁 Discount & Exit-Intent Offer Designs (17 Templates)
1. **Exit-Offer Special Downsell** (`SpecialOfferDownsellPaywallView`): Exit-intent 1-offering deal with live ticking timer & 75% OFF badge.
2. **24H Flash Sale Event** (`FlashSaleBannerPaywallView`): Urgency marquee ticker, claim meter & instant voucher coupon code.
3. **Lifetime VIP Value Anchor** (`TwoTierUpgradeDiscountPaywallView`): Value math breakdown comparing recurring annual vs lifetime pass.
4. **Scratch & Reveal Mystery Deal** (`ScratchToRevealDiscountPaywallView`): Gamified scratch-off mystery voucher with celebratory confetti particles.
5. **Empathetic Win-Back Offer** (`WinBackRetentionPaywallView`): Empathetic indie developer 50% community grant for price-sensitive users.
6. **Spin to Win Lucky Wheel** (`SpinToWinWheelDiscountPaywallView`): Interactive spinning fortune wheel landing on 70% off with haptic bursts.
7. **Holiday Seasonal Gift Box** (`HolidaySeasonalGiftDiscountPaywallView`): Holiday seasonal gift unboxing with festive ribbon bounce.
8. **Student & Creator Grant** (`StudentCreatorGrantDiscountPaywallView`): 60% academic & creator aid grant with verified educational badge.
9. **Abandoned Cart iOS Alert** (`AbandonedCartNotificationDiscountPaywallView`): Simulated iOS lockscreen push alert from founder with $20 credit voucher.
10. **Low-Friction Trial Extension** (`AnnualVsMonthlyFrictionKillerPaywallView`): Risk-reversal low installment terms with zero upfront friction.
11. **Early Bird Launch (#500 Spots)** (`EarlyBirdLaunchDiscountPaywallView`): Founding member certificate #384 of 500 with lifetime grandfathered rate.
12. **Founder's Personal Letter (50%)** (`FounderPersonalLetterDiscountPaywallView`): Heartfelt personal note & signature from solo creator with 50% discount.
13. **Pay-What-You-Want Scale** (`PayWhatYouWantSlidingDiscountPaywallView`): Customizable contribution slider ($19 - $99) supporting open-source software.
14. **Refer a Friend 50/50 Pass** (`ReferAFriendUnlockDiscountPaywallView`): Viral 2-way referral coupon with copyable code FRIEND50-VIP and friend avatars.
15. **Neon Flash Cyber Sale (70%)** (`SeasonalSpringBlackFridayDarkNeonPaywallView`): High-octane cyberpunk neon mega flash sale with live countdown clock.
16. **Timezone Hold Reservation (2 Left)** (`LimitedSpotsRemainingScarcityPaywallView`): Geo-targeted capacity hold timer reserving slot #92 with lock-in guarantee.
17. **iCloud Family Sharing Split ($0.83/mo)** (`FamilySharingSplitBillingPaywallView`): Interactive family stepper calculating split price down to $0.83 / mo / member.

---

## 📐 Layout Architecture: Pinned Bottom Dock & Zero Trimming

Every template adheres strictly to iOS design standards:
- **Stationary Pinned Bottom Dock**: Plan cards, primary CTA, and restore/terms legal footers stay fixed at the bottom while rich top visual features scroll independently.
- **Zero Text Clipping**: Full-width vertical cards with `.lineLimit(1)` and `.minimumScaleFactor(0.85)` ensuring plans and prices never truncate or wrap awkwardly on any iPhone screen size (mini through Pro Max).

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

## 📱 Interactive Showcase App

A complete iOS showcase catalog application is included in `PaywallShowcase`:

1. Open `PaywallShowcase/PaywallShowcase.xcodeproj` in Xcode.
2. Select any iOS Simulator (e.g. **iPhone 17**, **iPhone 17 Pro**, or **iPhone 18 Pro**).
3. Press **`Cmd + R`** to run.
4. Browse all 40 paywalls categorized into **All (40)**, **General Archetypes (23)**, and **Discount Offers (17)**!

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
