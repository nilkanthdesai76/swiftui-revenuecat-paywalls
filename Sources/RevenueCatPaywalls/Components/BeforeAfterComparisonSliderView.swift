import SwiftUI

public struct BeforeAfterComparisonSliderView: View {
    @State private var sliderPosition: CGFloat = 0.5
    public var accentColor: Color
    
    public init(accentColor: Color = Color(red: 0.38, green: 0.35, blue: 0.98)) {
        self.accentColor = accentColor
    }
    
    public var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let dividerX = max(20, min(width - 20, width * sliderPosition))
            
            ZStack(alignment: .leading) {
                // Background Layer: Free Tier (Left representation)
                freeTierLayer(width: width, height: height)
                
                // Foreground Layer: Pro Tier (Clipped to right side of divider)
                proTierLayer(width: width, height: height)
                    .clipShape(
                        Path { path in
                            path.addRect(CGRect(x: dividerX, y: 0, width: width - dividerX, height: height))
                        }
                    )
                
                // Draggable Divider Bar & Handle
                dividerHandle(dividerX: dividerX, height: height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newFraction = value.location.x / width
                                sliderPosition = max(0.1, min(0.9, newFraction))
                            }
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
        }
        .frame(height: 220)
    }
    
    // MARK: - Subviews
    
    private func freeTierLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.15, green: 0.15, blue: 0.18), Color(red: 0.08, green: 0.08, blue: 0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Image(systemName: "photo.badge.exclamationmark")
                    .font(.system(size: 38))
                    .foregroundColor(.white.opacity(0.4))
                
                Text("FREE TIER")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                
                VStack(spacing: 4) {
                    Text("• Low 720p Resolution")
                    Text("• App Watermark Embedded")
                    Text("• 3 Exports Daily Limit")
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.45))
            }
            .padding(.trailing, width * 0.45)
            
            // "FREE" Badge Tag
            VStack {
                HStack {
                    Text("FREE")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.15), in: Capsule())
                    Spacer()
                }
                Spacer()
            }
            .padding(12)
        }
    }
    
    private func proTierLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            LinearGradient(
                colors: [accentColor.opacity(0.85), Color(red: 0.1, green: 0.05, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.4), radius: 8)
                
                Text("PRO UNLOCKED")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 4) {
                    Text("✓ Crystal 4K HDR Quality")
                    Text("✓ No Watermarks Ever")
                    Text("✓ Unlimited Studio Exports")
                }
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
            }
            .padding(.leading, width * 0.45)
            
            // "PRO" Badge Tag
            VStack {
                HStack {
                    Spacer()
                    Text("PRO")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.3), in: Capsule())
                }
                Spacer()
            }
            .padding(12)
        }
    }
    
    private func dividerHandle(dividerX: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 2.5, height: height)
                .shadow(color: Color.black.opacity(0.5), radius: 3)
            
            Circle()
                .fill(Color.white)
                .frame(width: 34, height: 34)
                .shadow(color: Color.black.opacity(0.35), radius: 6, y: 2)
                .overlay(
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 10, weight: .bold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.black)
                )
        }
        .position(x: dividerX, y: height / 2)
    }
}
