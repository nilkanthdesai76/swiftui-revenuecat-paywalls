import SwiftUI

public struct ShimmerEffectModifier: ViewModifier {
    @State private var phase: CGFloat = -1.0
    public var duration: Double = 1.8
    public var bounce: Bool = false
    
    public init(duration: Double = 1.8, bounce: Bool = false) {
        self.duration = duration
        self.bounce = bounce
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.35), location: 0.5),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width * 1.5)
                    .offset(x: phase * geo.size.width * 1.5)
                    .blendMode(.screen)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: bounce)
                ) {
                    phase = 1.5
                }
            }
    }
}

public extension View {
    func shimmering(duration: Double = 1.8, bounce: Bool = false) -> some View {
        modifier(ShimmerEffectModifier(duration: duration, bounce: bounce))
    }
}
