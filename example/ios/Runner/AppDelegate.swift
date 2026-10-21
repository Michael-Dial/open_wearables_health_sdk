import Flutter
import UIKit
import OpenWearablesHealthSDK
import open_wearables_health_sdk

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // The SDK registers its BGTaskScheduler handlers when `shared` is first
    // created, and iOS rejects registration after launch finishes. Plugins now
    // register later, once the scene creates the Flutter engine, so create the
    // SDK here.
    _ = OpenWearablesHealthSDK.shared
    // A background launch (HealthKit delivering new samples, a BGTask) connects
    // no scene, so the engine and Dart's configure never run. HealthKit delivers
    // only to observer queries this process has running, so register them here.
    OpenWearablesHealthSDK.shared.restoreBackgroundSyncAtLaunch()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  override func application(_ application: UIApplication,
                            handleEventsForBackgroundURLSession identifier: String,
                            completionHandler: @escaping () -> Void) {
    OpenWearablesHealthSdkPlugin.setBackgroundCompletionHandler(completionHandler)
  }
}
