
import Foundation
import SwiftUI

// MARK: - Screenshot Protection ViewModifier
struct ScreenshotProtectionModifier: ViewModifier {
    @State private var blurIntensity: Double = 0.5
    @State private var blackOpacity: Double = 0.4
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            // Blur overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(blurIntensity)
                .allowsHitTesting(false)
            
            // Black overlay
            Color.black
                .opacity(blackOpacity)
                .allowsHitTesting(false)
        }
        .onAppear {
            setupScreenshotDetection()
            setupScreenRecordingDetection()
        }
    }
    
    private func setupScreenshotDetection() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { _ in
            showToast(message: "⚠️ Screenshot detected - Content is protected")
        }
    }
    
    private func setupScreenRecordingDetection() {
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            if UIScreen.main.isCaptured {
                // Increase protection during recording
                withAnimation {
                    blurIntensity = 1.0
                    blackOpacity = 0.8
                }
                showToast(message: "⚠️ Screen recording detected")
            } else {
                // Return to normal
                withAnimation {
                    blurIntensity = 0.5
                    blackOpacity = 0.4
                }
            }
        }
    }
    
    private func showToast(message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.95)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        toastLabel.numberOfLines = 2
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true
        toastLabel.tag = 7777
        
        let width = window.frame.width - 40
        toastLabel.frame = CGRect(
            x: 20,
            y: window.safeAreaInsets.top + 20,
            width: width,
            height: 60
        )
        
        toastLabel.alpha = 0
        window.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3) {
            toastLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4, delay: 2.5, options: .curveEaseOut) {
            toastLabel.alpha = 0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

/*// MARK: - View Extension
extension View {
    func screenshotProtected(blurIntensity: Double = 0.5, blackOpacity: Double = 0.4) -> some View {
        self.modifier(ScreenshotProtectionModifier())
    }
}*/
// MARK: - View Extension
extension View {
    func screenshotProtected(blurIntensity: Double = 8.9, blackOpacity: Double = 0.1) -> some View {
        self.modifier(ScreenshotProtectionModifier())
    }
}
