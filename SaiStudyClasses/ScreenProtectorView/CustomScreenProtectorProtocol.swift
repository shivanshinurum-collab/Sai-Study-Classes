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


/*
///Same ScreenProtector Kit

import UIKit

public final class CustomScreenProtectorKit {

    private weak var window: UIWindow?
    private var secureTextField: UITextField?
    private var secureContainer: UIView?

    // MARK: - Init
    public init(window: UIWindow?) {
        self.window = window
    }

    // MARK: - Enable Protection (INSTANT)
    public func enable() {
        guard
            secureTextField == nil,
            let window = window,
            let rootView = window.rootViewController?.view
        else { return }

        // 1️⃣ Secure text field
        let textField = UITextField(frame: rootView.bounds)
        textField.isSecureTextEntry = true
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .clear

        // 2️⃣ Secure container (this is the magic view)
        guard let secureView = textField.subviews.first else { return }
        secureView.frame = rootView.bounds
        secureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        secureView.isUserInteractionEnabled = false

        // 3️⃣ Move real UI INSIDE secure container
        rootView.removeFromSuperview()
        secureView.addSubview(rootView)

        // 4️⃣ Put secure container back into window
        window.addSubview(secureView)

        self.secureTextField = textField
        self.secureContainer = secureView
    }

    // MARK: - Disable Protection (Optional)
    public func disable() {
        guard
            let window = window,
            let rootView = window.rootViewController?.view,
            let secureContainer = secureContainer
        else { return }

        rootView.removeFromSuperview()
        window.addSubview(rootView)

        secureContainer.removeFromSuperview()
        secureTextField = nil
        self.secureContainer = nil
    }
}
*/

/*import UIKit

// MARK: - Protocol (ScreenProtectorKit style)
public protocol CustomScreenProtectorProtocol {
    func setWindow(_ window: UIWindow)
    func startObservers()
    func stopObservers()
    func showScreen(forScreenshot: Bool)
    func hideScreen()
}

// MARK: - Custom Screen Protector
public final class CustomScreenProtectorKit: CustomScreenProtectorProtocol {

    // MARK: - Properties
    private weak var window: UIWindow?
    private var screenshotObserver: NSObjectProtocol?
    private var screenRecordObserver: NSObjectProtocol?
    private let overlayView: UIView

    public init(window: UIWindow) {
        self.window = window
        self.overlayView = Self.createOverlayView()

        // Pre-attach overlay to minimize delay
        overlayView.frame = window.bounds
        overlayView.alpha = 0
        overlayView.isHidden = true
        window.addSubview(overlayView)
    }


    // MARK: - Window
    public func setWindow(_ window: UIWindow) {
        self.window = window
        // Update overlay frame
        overlayView.frame = window.bounds
        if overlayView.superview == nil {
            window.addSubview(overlayView)
        }
    }

    // MARK: - Start / Stop Observers
    public func startObservers() {
        startScreenshotObserver()
        startScreenRecordingObserver()
    }

    public func stopObservers() {
        stopScreenshotObserver()
        stopScreenRecordingObserver()
    }

    // MARK: - Screenshot Observer
    private func startScreenshotObserver() {
        guard screenshotObserver == nil else { return }

        screenshotObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.showScreen(forScreenshot: true)
        }
    }

    private func stopScreenshotObserver() {
        if let observer = screenshotObserver {
            NotificationCenter.default.removeObserver(observer)
            screenshotObserver = nil
        }
    }

    // MARK: - Screen Recording Observer
    private func startScreenRecordingObserver() {
        guard screenRecordObserver == nil else { return }

        screenRecordObserver = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }

            if UIScreen.main.isCaptured {
                self.showScreen(forScreenshot: false)
            } else {
                self.hideScreen()
            }
        }

        // If recording is already active at launch
        if UIScreen.main.isCaptured {
            showScreen(forScreenshot: false)
        }
    }

    private func stopScreenRecordingObserver() {
        if let observer = screenRecordObserver {
            NotificationCenter.default.removeObserver(observer)
            screenRecordObserver = nil
        }
    }

    // MARK: - Show / Hide Overlay
    public func showScreen(forScreenshot: Bool) {
        overlayView.alpha = 1
        overlayView.isHidden = false

        if forScreenshot {
            // Auto-hide after 2 seconds for screenshots
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.hideScreen()
            }
        }
    }

    public func hideScreen() {
        UIView.animate(withDuration: 0.25) {
            self.overlayView.alpha = 0
        } completion: { _ in
            self.overlayView.isHidden = true
        }
    }

    // MARK: - Overlay UI
    private static func createOverlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)

        let label = UILabel()
        label.text = "⚠️ Screen Capture Detected\nThis content is protected"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        return view
    }

    // MARK: - Deinit
    deinit {
        stopObservers()
    }
}
*/
