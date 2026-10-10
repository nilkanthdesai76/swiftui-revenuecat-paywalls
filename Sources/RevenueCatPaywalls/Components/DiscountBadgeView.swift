import SwiftUI

public struct DiscountBadgeView: View {
    public let text: String
    public var backgroundColor: Color
    public var textColor: Color
    public var enableShimmer: Bool
    
    public init(
        text: String,
        backgroundColor: Color = Color(red: 0.95, green: 0.25, blue: 0.35),
        textColor: Color = .white,
        enableShimmer: Bool = true
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.enableShimmer = enableShimmer
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundColor(textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(backgroundColor)
                    .shadow(color: backgroundColor.opacity(0.4), radius: 6, y: 2)
            )
            .if(enableShimmer) { view in
                view.shimmering(duration: 2.2)
            }
    }
}

// Helper for conditional view modifiers
public extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
