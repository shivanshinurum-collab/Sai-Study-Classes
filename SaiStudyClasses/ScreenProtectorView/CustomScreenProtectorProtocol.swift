import UIKit

public final class CustomScreenProtectorKit {

    private weak var window: UIWindow?
    private var secureTextField: UITextField?
    private var secureContainer: UIView?
    private var overlayView: UIView?

    public init(window: UIWindow?) {
        self.window = window
    }

    // MARK: - Enable Protection
    public func enable() {
        guard
            secureTextField == nil,
            let window,
            let rootView = window.rootViewController?.view
        else { return }

        // Secure text field
        let textField = UITextField(frame: rootView.bounds)
        textField.isSecureTextEntry = true
        textField.isUserInteractionEnabled = false

        guard let secureView = textField.subviews.first else { return }
        secureView.frame = rootView.bounds
        secureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Move real UI into secure container
        rootView.removeFromSuperview()
        secureView.addSubview(rootView)

        // Add secure container to window
        window.addSubview(secureView)

        self.secureTextField = textField
        self.secureContainer = secureView

        setupOverlay()
    }

    // MARK: - Custom Screen (VISIBLE TO USER)
    private func setupOverlay() {
        guard let secureContainer else { return }

        let overlay = UIView(frame: secureContainer.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        overlay.isHidden = true
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let label = UILabel()
        label.text = "⚠️ Screen Capture Disabled\nThis content is protected"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        overlay.addSubview(label)
        secureContainer.addSubview(overlay)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -24)
        ])

        self.overlayView = overlay
    }

    // MARK: - Show / Hide Custom Screen
    public func showCustomScreen() {
        overlayView?.isHidden = false
    }

    public func hideCustomScreen() {
        overlayView?.isHidden = true
    }
}

