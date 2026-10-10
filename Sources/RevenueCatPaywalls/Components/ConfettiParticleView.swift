import SwiftUI

public struct ConfettiParticleView: View {
    public let isEmitting: Bool
    public var particleCount: Int
    
    public init(isEmitting: Bool, particleCount: Int = 36) {
        self.isEmitting = isEmitting
        self.particleCount = particleCount
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                if isEmitting {
                    ForEach(0..<particleCount, id: \.self) { index in
                        ConfettiPiece(index: index, size: proxy.size)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

private struct ConfettiPiece: View {
    let index: Int
    let size: CGSize
    
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 1.0
    @State private var rotation: Double = 0.0
    @State private var scale: CGFloat = 1.0
    
    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink
    ]
    
    var body: some View {
        let color = colors[index % colors.count]
        let shapeType = index % 3
        
        Group {
            if shapeType == 0 {
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 8, height: 14)
            } else if shapeType == 1 {
                Circle()
                    .fill(color)
                    .frame(width: 9, height: 9)
            } else {
                Image(systemName: "sparkle")
                    .font(.system(size: 10))
                    .foregroundColor(color)
            }
        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .position(position)
        .opacity(opacity)
        .onAppear {
            let startX = size.width / 2 + CGFloat.random(in: -30...30)
            let startY = size.height / 2 + CGFloat.random(in: -20...20)
            position = CGPoint(x: startX, y: startY)
            
            let angle = Double.random(in: 0...(2 * .pi))
            let distance = CGFloat.random(in: 80...260)
            let endX = startX + cos(angle) * distance
            let endY = startY + sin(angle) * distance + CGFloat.random(in: 40...140)
            
            withAnimation(.easeOut(duration: Double.random(in: 1.2...1.8))) {
                position = CGPoint(x: endX, y: endY)
                rotation = Double.random(in: 180...720)
                scale = CGFloat.random(in: 0.6...1.3)
            }
            
            withAnimation(.easeIn(duration: 0.6).delay(0.9)) {
                opacity = 0.0
            }
        }
    }
}
