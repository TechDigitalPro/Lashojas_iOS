//
//  AppDelegate.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
import FirebaseMessaging
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    let fcmTopic = "Lashojas_Remote_Notification"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey("AIzaSyCSLbdLQQXkFi2NgsYXtou2qF3nmEz5zhE")
        GMSPlacesClient.provideAPIKey("AIzaSyCSLbdLQQXkFi2NgsYXtou2qF3nmEz5zhE")
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: fcmTopic)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        if (Messaging.messaging().fcmToken != nil) {
            print("FCM token: \(Messaging.messaging().fcmToken)")
        } else {
           print("token was nil")
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      #if PROD_BUILD
        Messaging.messaging().apnsToken = deviceToken
      #else
        Messaging.messaging().apnsToken = deviceToken
      #endif
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        Messaging.messaging().appDidReceiveMessage(userInfo)
       
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Notification: basic delegate")
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
    }
    
    // MARK:- App Lifecycle
    func goMain() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            UIApplication.shared.windows.first?.rootViewController = vc
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        print("will present message")
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID(present): \(messageID)")
        }

        let noti_type = userInfo["noti_type"] as? String ?? "normal"
        if noti_type == "geo" {
            let lat = Double(userInfo["lat"] as? String ?? "0") ?? 0
            let long = Double(userInfo["long"] as? String ?? "0") ?? 0
            let radius = Double(userInfo["radius"] as? String ?? "0") ?? 0
            if let location = MyLocation {
                let s_loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
                let t_loc = CLLocation(latitude: lat, longitude: long)
                let distance = s_loc.distance(from: t_loc)
                if (distance <= radius) {
                    completionHandler([.alert, .badge, .sound])
                }
            }
        } else {
            completionHandler([.alert, .badge, .sound])
        }

    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("received message")
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID(receive): \(messageID)")
        }
        
        let noti_type = userInfo["noti_type"] as? String ?? "normal"
        if noti_type == "geo" {
            let lat = Double(userInfo["lat"] as? String ?? "0") ?? 0
            let long = Double(userInfo["long"] as? String ?? "0") ?? 0
            let radius = Double(userInfo["radius"] as? String ?? "0") ?? 0
            if let location = MyLocation {
                let s_loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
                let t_loc = CLLocation(latitude: lat, longitude: long)
                let distance = s_loc.distance(from: t_loc)
                if (distance <= radius) {
                    completionHandler()
                }
            }
        } else {
            completionHandler()
        }
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase refresh token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}

