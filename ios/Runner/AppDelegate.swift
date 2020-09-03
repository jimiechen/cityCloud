import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var pushChannel:FlutterMethodChannel?;
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    pushChannel = FlutterMethodChannel(name: "custom_push",
                                           binaryMessenger: controller.binaryMessenger)
    pushChannel!.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      // Handle battery messages.
        result(true);
        self.pushChannel!.invokeMethod("native", arguments: "hello")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.pushChannel!.invokeMethod("delay", arguments: "hello")
        }
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
               self.pushChannel!.invokeMethod("hello", arguments: "hello")
           }
    let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
    let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
    application.registerUserNotificationSettings(pushNotificationSettings)
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    print("DEVICE TOKEN = \(deviceToken)")
    pushChannel!.invokeMethod("token", arguments: "hello")
  }

  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print(error)
  }

  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    print(userInfo)
  }
}


