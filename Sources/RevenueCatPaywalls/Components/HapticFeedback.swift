import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum HapticFeedback {
    public static func light() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    public static func medium() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    public static func selection() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
    
    public static func success() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }
    
    public static func error() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
        #endif
    }
}
