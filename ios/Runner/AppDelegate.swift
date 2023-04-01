import UIKit
import Flutter
import flutter_local_notifications
import GoogleMaps
import GooglePlaces
import flutter_background_service_ios // add this


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAAo6dJIw1f_g-WmGis0wtgb29E_EslM0I")
    GMSPlacesClient.provideAPIKey("AIzaSyAAo6dJIw1f_g-WmGis0wtgb29E_EslM0I")

    GeneratedPluginRegistrant.register(with: self)

    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"

    if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
