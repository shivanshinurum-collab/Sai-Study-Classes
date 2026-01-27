import SwiftUI
import CoreData
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import ScreenProtectorKit //  Add the package

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {

    var window: UIWindow?
    private var screenProtector: ScreenProtectorKit?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Initialize ScreenProtectorKit with main window (will be nil at launch, so create after UI appears)
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first {
                self.screenProtector = ScreenProtectorKit(window: keyWindow)
                self.screenProtector?.configurePreventionScreenshot()
                self.screenProtector?.enabledPreventScreenshot()
            }
        }

        // Configure Firebase
        FirebaseApp.configure()

        // Set up Firebase Messaging
        Messaging.messaging().delegate = self

        // Set up notification center delegate
        UNUserNotificationCenter.current().delegate = self

        // Request notification permissions
        requestNotificationPermission()

        // Register for remote notifications
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }

        return true
    }

    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                print(" Notification Permission granted: \(granted)")
                if let error = error {
                    print(" Error requesting notification permission: \(error.localizedDescription)")
                }
            }
        )
    }

    // Blur screen when app goes inactive (banking style)
    func applicationWillResignActive(_ application: UIApplication) {
        screenProtector?.enabledBlurScreen()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        screenProtector?.disableBlurScreen()
        screenProtector?.enabledPreventScreenshot()
    }

    // MARK: - Remote Notification Handlers
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print(" APNs Device Token: \(token)")

        Messaging.messaging().apnsToken = deviceToken

        Messaging.messaging().token { fcmToken, error in
            if let error = error {
                print(" Error fetching FCM token: \(error.localizedDescription)")
            } else if let fcmToken = fcmToken {
                print(" FCM Token: \(fcmToken)")
                UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
                NotificationCenter.default.post(
                    name: NSNotification.Name("FCMTokenUpdated"),
                    object: nil,
                    userInfo: ["token": fcmToken]
                )
            }
        }
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(" Failed to register for remote notifications: \(error.localizedDescription)")
        #if targetEnvironment(simulator)
        print(" Push notifications don't work on simulator. Please test on a real device.")
        #endif
    }
}

// MARK: - Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "FCMToken")
            NotificationCenter.default.post(
                name: NSNotification.Name("FCMTokenUpdated"),
                object: nil,
                userInfo: ["token": token]
            )
            print(" FCM Token updated: \(token)")
        }
    }
}

// MARK: - UNUserNotificationCenter Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        print(" Notification received in foreground: \(userInfo)")
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        print(" Notification tapped: \(userInfo)")
        completionHandler()
    }
}

// MARK: - SwiftUI App Entry
@main
struct SaiStudyClassesApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationManager()
                .onAppear {
                    // Listen for FCM token updates
                    NotificationCenter.default.addObserver(
                        forName: NSNotification.Name("FCMTokenUpdated"),
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let token = notification.userInfo?["token"] as? String {
                            print("🎯 FCM Token updated in app: \(token)")
                        }
                    }
                }
        }
    }
}




/*

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import ScreenProtectorKit

// MARK: - Secure Window
final class SecureWindow: UIWindow {
    private let secureField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        secureField.isSecureTextEntry = true
        secureField.isUserInteractionEnabled = false
        secureField.backgroundColor = .clear
        addSubview(secureField)
        secureField.frame = bounds
    }
}

// MARK: - SwiftUI Global Screen Protection
struct GlobalScreenProtection: ViewModifier {

    @State private var isCaptured = UIScreen.main.isCaptured
    @State private var hideForScreenshot = false

    func body(content: Content) -> some View {
        ZStack {
            if isCaptured || hideForScreenshot {
                Color.black.ignoresSafeArea()
            } else {
                content
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { _ in
            isCaptured = UIScreen.main.isCaptured
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
            hideForScreenshot = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                hideForScreenshot = false
            }
        }
    }
}

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {

    var window: UIWindow?
    private var screenProtector: ScreenProtectorKit?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        // 🔐 Secure Window
        let secureWindow = SecureWindow(frame: UIScreen.main.bounds)

        // SwiftUI root view with GlobalScreenProtection
        let rootView = NavigationManager()
            .modifier(GlobalScreenProtection())

        let hostingController = UIHostingController(rootView: rootView)
        secureWindow.rootViewController = hostingController
        secureWindow.makeKeyAndVisible()
        self.window = secureWindow

        // ScreenProtectorKit for additional protection
        screenProtector = ScreenProtectorKit(window: secureWindow)
        screenProtector?.configurePreventionScreenshot()
        screenProtector?.enabledPreventScreenshot()

        // Firebase
        FirebaseApp.configure()

        // Push Notifications
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }

        return true
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            print("Notification Permission:", granted)
            if let error = error {
                print("Notification error:", error.localizedDescription)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        screenProtector?.enabledBlurScreen()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        screenProtector?.disableBlurScreen()
        screenProtector?.enabledPreventScreenshot()
    }
}

// MARK: - Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("FCM Token:", token)
            UserDefaults.standard.set(token, forKey: "FCMToken")
        }
    }
}

// MARK: - Notification Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }
}

// MARK: - SwiftUI App Entry
@main
struct SaiStudyClassesApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationManager()
                .modifier(GlobalScreenProtection())
                .onAppear {
                    NotificationCenter.default.addObserver(
                        forName: NSNotification.Name("FCMTokenUpdated"),
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let token = notification.userInfo?["token"] as? String {
                            print("🎯 FCM Token updated in app: \(token)")
                        }
                    }
                }
        }
    }
}
*/


/*
import SwiftUI
import CoreData
import FirebaseCore
import FirebaseMessaging
import UserNotifications

// AppDelegate to handle Firebase configuration
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Set up Firebase Messaging
        Messaging.messaging().delegate = self
        
        // Set up notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        requestNotificationPermission()
        
        // Register for remote notifications
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
        
        return true
    }
    
    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                print("🔔 Notification Permission granted: \(granted)")
                if let error = error {
                    print("❌ Error requesting notification permission: \(error.localizedDescription)")
                }
            }
        )
    }
    
    // Handle successful registration for remote notifications
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("✅ APNs Device Token: \(token)")
        
        // Pass the device token to Firebase
        Messaging.messaging().apnsToken = deviceToken
        
        // Now try to get FCM token
        Messaging.messaging().token { fcmToken, error in
            if let error = error {
                print("❌ Error fetching FCM token: \(error.localizedDescription)")
            } else if let fcmToken = fcmToken {
                print("🔥 FCM Token: \(fcmToken)")
                UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
            }
        }
    }
    
    // Handle failure to register for remote notifications
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
        
        #if targetEnvironment(simulator)
        print("⚠️ Push notifications don't work on simulator. Please test on a real device.")
        #endif
    }
}

// MARK: - Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 Firebase registration token: \(fcmToken ?? "No token")")
        
        // Store the token
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "FCMToken")
            print("✅ FCM Token saved successfully")
            print("📱 Your Token: \(token)")
            
            // Optional: Send token to your backend server
            // sendTokenToServer(token)
            
            // Post notification for other parts of app to listen
            NotificationCenter.default.post(
                name: NSNotification.Name("FCMTokenUpdated"),
                object: nil,
                userInfo: ["token": token]
            )
        }
    }
}

// MARK: - UNUserNotificationCenter Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("📬 Notification received in foreground: \(userInfo)")
        
        // Show notification even when app is in foreground
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("👆 Notification tapped: \(userInfo)")
        
        // Handle the notification action here
        
        completionHandler()
    }
}

@main
struct SaiStudyClassesApp: App {
    //let persistenceController = PersistenceController.shared
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
          NavigationManager()
                .onAppear {
                    // Listen for FCM token updates
                    NotificationCenter.default.addObserver(
                        forName: NSNotification.Name("FCMTokenUpdated"),
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let token = notification.userInfo?["token"] as? String {
                            print("🎯 FCM Token updated in app: \(token)")
                        }
                    }
                }
        }
    }
}*/

