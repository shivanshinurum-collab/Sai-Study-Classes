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
}
