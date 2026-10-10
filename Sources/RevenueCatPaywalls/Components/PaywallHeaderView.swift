import SwiftUI

public struct PaywallHeaderView: View {
    public let onDismiss: () -> Void
    public var onRestore: (() -> Void)?
    public var delaySeconds: Double
    public var tintColor: Color
    
    @State private var isVisible: Bool = false
    
    public init(
        delaySeconds: Double = 0.0,
        tintColor: Color = .primary,
        onRestore: (() -> Void)? = nil,
        onDismiss: @escaping () -> Void
    ) {
        self.delaySeconds = delaySeconds
        self.tintColor = tintColor
        self.onRestore = onRestore
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        HStack {
            // Optional Top Restore Button
            if let onRestore = onRestore {
                Button(action: {
                    HapticFeedback.light()
                    onRestore()
                }) {
                    Text("Restore")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(tintColor.opacity(0.75))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }
            
            Spacer()
            
            // Dismiss Button
            if isVisible {
                Button(action: {
                    HapticFeedback.light()
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(tintColor.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .onAppear {
            if delaySeconds <= 0 {
                isVisible = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isVisible = true
                    }
                }
            }
        }
    }
}
