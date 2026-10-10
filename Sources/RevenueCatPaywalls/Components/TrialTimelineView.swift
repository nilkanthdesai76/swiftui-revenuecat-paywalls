import SwiftUI

public struct TrialTimelineView: View {
    public let steps: [TrialTimelineStep]
    public var accentColor: Color
    
    public init(
        steps: [TrialTimelineStep] = MockData.sampleTimelineSteps,
        accentColor: Color = Color(red: 0.38, green: 0.35, blue: 0.98)
    ) {
        self.steps = steps
        self.accentColor = accentColor
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 14) {
                    // Left Timeline Track & Node
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(nodeBackgroundColor(for: step.status))
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: step.icon)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(nodeIconColor(for: step.status))
                        }
                        
                        // Connecting line between steps
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [accentColor.opacity(0.6), accentColor.opacity(0.15)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 2, height: 42)
                        }
                    }
                    .frame(width: 28)
                    
                    // Content Info
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(step.dayLabel)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(accentColor)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(accentColor.opacity(0.12), in: Capsule())
                            
                            Text(step.title)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        
                        Text(step.detail)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                            .padding(.bottom, index < steps.count - 1 ? 16 : 0)
                    }
                    
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(accentColor.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func nodeBackgroundColor(for status: TimelineStepStatus) -> Color {
        switch status {
        case .completed:
            return accentColor
        case .active:
            return accentColor.opacity(0.2)
        case .upcoming:
            return Color.secondary.opacity(0.15)
        }
    }
    
    private func nodeIconColor(for status: TimelineStepStatus) -> Color {
        switch status {
        case .completed:
            return .white
        case .active:
            return accentColor
        case .upcoming:
            return .secondary
        }
    }
}
