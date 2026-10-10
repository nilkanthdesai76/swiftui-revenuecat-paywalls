import SwiftUI

public struct SpinningWheelView: View {
    @Binding public var isSpinning: Bool
    @Binding public var hasLanded: Bool
    public var onFinished: () -> Void
    
    @State private var rotationDegrees: Double = 0
    
    private let sectors: [(text: String, color: Color)] = [
        ("70% OFF", Color(red: 0.95, green: 0.25, blue: 0.35)),
        ("30% OFF", Color(red: 0.25, green: 0.55, blue: 0.95)),
        ("50% OFF", Color(red: 0.95, green: 0.65, blue: 0.15)),
        ("FREE MONTH", Color(red: 0.20, green: 0.75, blue: 0.45)),
        ("60% OFF", Color(red: 0.65, green: 0.35, blue: 0.95)),
        ("40% OFF", Color(red: 0.05, green: 0.75, blue: 0.85))
    ]
    
    public init(
        isSpinning: Binding<Bool>,
        hasLanded: Binding<Bool>,
        onFinished: @escaping () -> Void
    ) {
        self._isSpinning = isSpinning
        self._hasLanded = hasLanded
        self.onFinished = onFinished
    }
    
    public var body: some View {
        ZStack {
            // Outer golden ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.yellow, Color.orange, Color.yellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 8
                )
                .frame(width: 220, height: 220)
                .shadow(color: Color.orange.opacity(0.4), radius: 10)
            
            // Spinning Wheel Disc
            ZStack {
                ForEach(0..<sectors.count, id: \.self) { index in
                    SectorSlice(
                        startAngle: Double(index) * (360.0 / Double(sectors.count)),
                        endAngle: Double(index + 1) * (360.0 / Double(sectors.count)),
                        color: sectors[index].color
                    )
                    
                    // Sector text
                    Text(sectors[index].text)
                        .font(.system(size: 9.5, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(Double(index) * 60 + 30))
                        .offset(y: -64)
                        .rotationEffect(.degrees(Double(index) * 60 + 30))
                }
            }
            .frame(width: 204, height: 204)
            .clipShape(Circle())
            .rotationEffect(.degrees(rotationDegrees))
            
            // Center Pin / Hub
            Circle()
                .fill(Color.white)
                .frame(width: 38, height: 38)
                .shadow(color: Color.black.opacity(0.3), radius: 4)
                .overlay(
                    Image(systemName: "sparkle")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.orange)
                )
            
            // Pointer Needle at top
            VStack {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.4), radius: 3, y: 2)
                    .offset(y: -108)
                Spacer()
            }
            .frame(height: 220)
        }
        .frame(width: 230, height: 230)
        .onChange(of: isSpinning) { spinning in
            if spinning {
                triggerSpin()
            }
        }
    }
    
    private func triggerSpin() {
        // Spin multiple full rotations and land on 70% OFF (top sector at 0 deg)
        let totalRotation = 360.0 * 5 + 0.0
        withAnimation(.timingCurve(0.15, 0.85, 0.25, 1.0, duration: 3.2)) {
            rotationDegrees += totalRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            hasLanded = true
            isSpinning = false
            HapticFeedback.success()
            onFinished()
        }
    }
}

private struct SectorSlice: View {
    let startAngle: Double
    let endAngle: Double
    let color: Color
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 102, y: 102))
            path.addArc(
                center: CGPoint(x: 102, y: 102),
                radius: 102,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(color)
    }
}
