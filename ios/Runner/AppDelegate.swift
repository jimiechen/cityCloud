import UIKit
import Flutter
import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UmengPushRegistrant.register(with: self.registrar(forPlugin: "UmengPush")!)
    ///申请广告表识
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            // Tracking authorization completed. Start loading ads here.
            // loadAd()
        })
    } else {
        // Fallback on earlier versions
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


