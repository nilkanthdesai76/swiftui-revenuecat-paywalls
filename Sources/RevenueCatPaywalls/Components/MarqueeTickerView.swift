import SwiftUI

public struct MarqueeTickerView: View {
    public let text: String
    public var backgroundColor: Color
    public var textColor: Color
    
    @State private var offset: CGFloat = 0
    
    public init(
        text: String,
        backgroundColor: Color = Color.red.opacity(0.15),
        textColor: Color = Color.red
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(textColor)
            
            Text(text)
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundColor(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            
            Image(systemName: "timer")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(textColor)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(textColor.opacity(0.35), lineWidth: 1)
                )
        )
    }
}
