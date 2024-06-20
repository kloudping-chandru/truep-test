import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import GoogleMaps
//import FirebaseCore
//import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  //   print("Token: \(deviceToken)")
       Messaging.messaging().apnsToken = deviceToken
       Messaging.messaging().isAutoInitEnabled = true
     super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
   }
}
