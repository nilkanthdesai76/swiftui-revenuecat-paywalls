import SwiftUI

public struct PaywallLegalFooterView: View {
    public var termsURL: URL?
    public var privacyURL: URL?
    public var onRestore: () -> Void
    public var textColor: Color
    
    public init(
        termsURL: URL? = URL(string: "https://example.com/terms"),
        privacyURL: URL? = URL(string: "https://example.com/privacy"),
        textColor: Color = .secondary,
        onRestore: @escaping () -> Void
    ) {
        self.termsURL = termsURL
        self.privacyURL = privacyURL
        self.textColor = textColor
        self.onRestore = onRestore
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Action links: Terms, Restore, Privacy
            HStack(spacing: 16) {
                if let termsURL = termsURL {
                    Link("Terms of Use", destination: termsURL)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(textColor.opacity(0.8))
                }
                
                Circle()
                    .fill(textColor.opacity(0.3))
                    .frame(width: 3, height: 3)
                
                Button(action: {
                    HapticFeedback.light()
                    onRestore()
                }) {
                    Text("Restore Purchases")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(textColor.opacity(0.8))
                }
                
                if let privacyURL = privacyURL {
                    Circle()
                        .fill(textColor.opacity(0.3))
                        .frame(width: 3, height: 3)
                    
                    Link("Privacy Policy", destination: privacyURL)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(textColor.opacity(0.8))
                }
            }
            
            // Legal subscription disclosure
            Text("Subscription auto-renews unless canceled at least 24h before renewal in Apple ID settings.")
                .font(.system(size: 9.5, weight: .regular))
                .foregroundColor(textColor.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 8)
    }
}
