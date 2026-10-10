import SwiftUI

public struct ActivityRingsView: View {
    @State private var ring1Progress: CGFloat = 0.0
    @State private var ring2Progress: CGFloat = 0.0
    @State private var ring3Progress: CGFloat = 0.0
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Outer Ring (Move / Burn) - Pink/Red
            ringCircle(progress: ring1Progress, color: Color(red: 0.98, green: 0.15, blue: 0.35), size: 130, strokeWidth: 12)
            
            // Middle Ring (Exercise / Streaks) - Lime/Green
            ringCircle(progress: ring2Progress, color: Color(red: 0.60, green: 0.95, blue: 0.15), size: 102, strokeWidth: 12)
            
            // Inner Ring (Stand / Focus) - Cyan/Blue
            ringCircle(progress: ring3Progress, color: Color(red: 0.0, green: 0.85, blue: 0.98), size: 74, strokeWidth: 12)
            
            // Center Trophy Icon
            Image(systemName: "flame.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 140, height: 140)
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.75).delay(0.2)) {
                ring1Progress = 0.88
            }
            withAnimation(.spring(response: 1.2, dampingFraction: 0.75).delay(0.35)) {
                ring2Progress = 0.72
            }
            withAnimation(.spring(response: 1.2, dampingFraction: 0.75).delay(0.5)) {
                ring3Progress = 0.95
            }
        }
    }
    
    private func ringCircle(progress: CGFloat, color: Color, size: CGFloat, strokeWidth: CGFloat) -> some View {
        ZStack {
            // Background track
            Circle()
                .stroke(color.opacity(0.2), lineWidth: strokeWidth)
                .frame(width: size, height: size)
            
            // Active arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .shadow(color: color.opacity(0.4), radius: 4)
        }
    }
}
