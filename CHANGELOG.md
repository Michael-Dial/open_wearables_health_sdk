## Unreleased

* **OWSync 1.0.4: HRV RMSSD whatever Xcode builds it.** The iOS SDK pin (Podfile, `Podfile.lock` and `Package.swift`) moves to `d8cf100`, which names HealthKit's iOS 27 RMSSD type by raw value instead of behind `#if compiler(>=6.4)`. Under that guard a build from a pre-27 Xcode compiled RMSSD out with no error: OWSync never asked for or uploaded it while SDNN kept syncing. The pin also follows the fork to its new home, `Michael-Dial/open_wearables_ios_sdk`, rather than relying on GitHub's redirect from `dial203/dial203-open_wearables_ios_sdk`; the SPM product's package identity changes with the URL.
* **OWSync 1.0.3: iOS SDK 0.16.0.** The iOS SDK pin (Podfile, `Podfile.lock` and `Package.swift`) moves to `f7b8013`, the fork's merge of upstream 0.16.0 (heart rate recovery, all HealthKit dietary types and food correlations). The podspec's native dependency moves from `~> 0.15.0` to `~> 0.16.0`, which the new pin needs to resolve. No change in what OWSync collects: Dart's `HealthDataType` still lists only five dietary types and no food correlation, so the new dietary types are not requested.
* **OWSync 1.0.2: reopening the app syncs.** The iOS SDK pin (Podfile and `Package.swift`) moves to `9df024f`, which adds to the launch restore that reopening a suspended app runs an incremental sync, at most every 2 minutes. A suspended app keeps its observers, so the launch catch-up never runs for it, and new data waited for a delivery or a manual stop and start.
* **OWSync background sync after the UIScene change (iOS)**: Apple Health data reached the backend only while OWSync was open, or after stopping and restarting sync. Since OWSync adopted the UIScene lifecycle the Flutter engine starts with the scene, which a background launch never connects, so Dart's `configure` never ran when HealthKit woke the app and no observer query was there to receive the delivery. `AppDelegate` now calls the native SDK's `restoreBackgroundSyncAtLaunch()` in `didFinishLaunching`. The SPM iOS SDK pin and the example app's Podfile pin move to `cd4a4da` of `dial203/dial203-open_wearables_ios_sdk`. OWSync 1.0.1.
* **Beat-to-beat capture (iOS, dial203 fork)**: `HealthDataType.heartbeatSeries` authorizes Apple Watch heartbeat series. Which series are uploaded is decided per participant on the backend (`off`, `sleep`, `all_day`, plus requested windows); the native SDK reads those instructions after each sync. Each beat arrives as the interval in ms since the previous beat at the beat's own time, in the backend's `pulse_to_pulse_interval` series. The SPM iOS SDK pin and the example app's Podfile pin move to `f41a35a` of `dial203/dial203-open_wearables_ios_sdk`. Ignored on Android, and under CocoaPods unless the app's Podfile points `OpenWearablesHealthSDK` at the fork (the podspec alone resolves upstream `~> 0.15.0`).
* iOS Swift Package Manager support (#52). CocoaPods still works. The native iOS SDK stays on `~> 0.15.0`.

## 0.0.25

* Bumped native Android SDK dependency from `v0.13.0` to `v0.13.1` (JitPack `com.github.the-momentum.open_wearables_android_sdk:sdk:v0.13.1`).
  - A partial Health Connect or Samsung Health grant is enough. Sync uploads the granted types, and Start Sync appears after that screen.
  - Samsung `activeEnergy` is active calories, not distance reported as kcal.
  - Samsung steps and active calories re-read the last 48 hours, aligned to the hour, so a late watch batch can replace that hour.

## 0.0.24

* Bumped native Android SDK dependency from `v0.12.0` to `v0.13.0` (JitPack `com.github.the-momentum.open_wearables_android_sdk:sdk:v0.13.0`).
  - Incremental sync uses Health Connect change tokens and Samsung `readChanges`, so backfilled records are no longer dropped.
  - Background sync starts immediately and retries when the device is locked. An open app reads 2000 records per page; background stays at 100.
  - `signOut()` tells the backend the connection was removed. Every `signIn()`, and switching between Samsung Health and Health Connect, starts a full export.
  - Samsung workout codes are sent as activity names, and integer body-composition values are no longer dropped.
  - Implausible timestamps are rejected, and Health Connect history permission is requested so full export is not limited to the recent window.

## 0.0.23

* Bumped native iOS SDK dependency from `~> 0.14.0` to `~> 0.15.0`.
* **iOS workout effort** (#51): `HealthDataType` now includes `workoutEffortScore` and `estimatedWorkoutEffortScore` (iOS 18+), plus the iOS aliases `restingEnergy` and `bloodOxygen`.
* **iOS tokenRefreshURL**: `configure(host:, tokenRefreshURL:)` forwards an optional absolute refresh endpoint to the native iOS SDK when the auth/mint server is not the sync host. Ignored on Android.
* **iOS cycling metrics** (#44 / #63): `HealthDataType` now includes `cyclingPower`, `cyclingCadence`, `cyclingSpeed`, and `cyclingFunctionalThresholdPower` so `HealthDataType.values` requests them during HealthKit authorization.
* **iOS running dynamics** (#13 / #55): `HealthDataType` now includes `runningPower`, `runningVerticalOscillation`, and `runningGroundContactTime` so `HealthDataType.values` requests them during HealthKit authorization.

## 0.0.22

* Bumped native Android SDK dependency from `v0.11.2` to `v0.12.0`.
  - Health Connect now reads power, speed, cycling cadence, and total calories (previously dropped silently).
  - Workout sessions include HR / power / speed / distance / calorie / cadence aggregates.
  - Descending pagination no longer re-includes range records; record-count page size capped at Health Connect's 5000 limit.

## 0.0.21

* Bumped native iOS SDK dependency from `~> 0.13.0` to `~> 0.14.0`.
* Bumped native Android SDK dependency from `v0.10.0` to `v0.11.2`.
* **iOS: fixed sync loop** — full export no longer gets poisoned into an infinite re-upload of old data on first-upload failure. Anchor capture errors and outbox retry storms also fixed.
* **Historical sync banner**: example app now shows "Historical data sync in progress" with a live record count while the initial export runs, and keeps the screen awake until it completes (`wakelock_plus`).
* **New `getSyncStatus()` keys**: `initialExportDone` and `isSyncing` exposed on both platforms.

## 0.0.20

* Bumped native iOS SDK dependency from `~> 0.12.0` to `~> 0.13.0`.
* Bumped native Android SDK dependency from `v0.9.0` to `v0.10.0`.
* **Sync telemetry**: both iOS and Android SDKs now send diagnostic events (`sync_start`, per-type `sync_end`, `device_state`) to the `/logs` endpoint during initial full syncs.
* **Android: auto full export**: first sync now automatically runs as full export, matching iOS behavior.
* **Android: fixed OkHttp connection leaks** in sync uploads and log requests.

## 0.0.19

* Bumped native iOS SDK dependency from `~> 0.11.0` to `~> 0.12.0`.
* **Source device name**: health data payloads now include a human-readable device `name` field alongside existing source metadata (via iOS SDK 0.12.0).

## 0.0.18

* Bumped native iOS SDK dependency from `~> 0.10.0` to `~> 0.11.0`.
* Bumped native Android SDK dependency from `v0.8.0` to `v0.9.0`.
* **Smarter disconnect behavior**: transient network errors during token refresh no longer force user sign-out — only genuine authentication failures (401/403) trigger disconnect.
* Added Sentry error logging to the example app for disconnect events and sync failures.

## 0.0.17

* **Breaking: Foreground service type changed from `dataSync` to `health`** to comply with Google Play policy. Apps must update their Play Console FGS declaration from "Data Sync" to "Health" and remove any manual `<service android:foregroundServiceType="dataSync">` from their `AndroidManifest.xml` — the SDK now provides the correct declaration via manifest merge.
* Added `FOREGROUND_SERVICE_HEALTH` and `HIGH_SAMPLING_RATE_SENSORS` permissions to the plugin manifest.
* Updated README with Android foreground service requirements, Play Console declaration guide, and mandatory `setSyncNotification()` usage.
* Bumped native Android SDK dependency from `v0.7.0` to `v0.8.0`.

## 0.0.16

* Bumped native iOS SDK dependency from `~> 0.9.0` to `~> 0.10.0`.
* Bumped native Android SDK dependency from `v0.6.0` to `v0.7.0`.
* Fixed `isSignedIn` returning `true` after `signOut()` — Dart-side state is now always cleared in a `finally` block.
* Fixed Android `signOut()` hanging if native call throws — wrapped in `try-catch` with guaranteed `result.success()`.
* Added `setSyncNotification(title, text)` — customize the Android foreground service notification shown during background sync (no-op on iOS).

## 0.0.15

* Bumped native iOS SDK dependency from `~> 0.8.0` to `~> 0.9.0`.
* Bumped native Android SDK dependency from `v0.5.0` to `v0.6.0`.

## 0.0.14

* Bumped native iOS SDK dependency from `~> 0.7.0` to `~> 0.8.0`.

## 0.0.13

* Added `syncDaysBack` parameter to `startBackgroundSync()` — control how many days of history to sync.
* Added `setLogLevel()` API with `OWLogLevel` enum (`none`, `always`, `debug`).
* SDK logs are now auto-printed to the Dart console based on the log level (debug by default).
* Bumped native iOS SDK dependency from `~> 0.6.0` to `~> 0.7.0`.
* Bumped native Android SDK dependency from `v0.4.0` to `v0.5.0`.

## 0.0.12

* Bumped native Android SDK dependency from `v0.3.0` to `v0.4.0`.

## 0.0.11

* Fixed LLDB "overlapping Mach-O section" warnings (`__TPRO_CONST` / `__DATA_CONST`) on iOS <17 devices when built with Xcode 15+.
* Added `-ld_classic` linker flag in Podfile to force legacy Mach-O section layout.
* Bumped native iOS SDK dependency from `~> 0.5.0` to `~> 0.6.0`.
* Aligned iOS deployment target to 15.0 across all podspecs.

## 0.0.10

* **Android support** — the plugin now works on both iOS and Android.
* Android implementation uses the [Open Wearables Android SDK](https://github.com/the-momentum/open_wearables_android_sdk) via JitPack — the Flutter plugin is a thin wrapper, same as on iOS.
* Dual health provider support on Android: **Samsung Health** and **Health Connect** with runtime selection (`setProvider`, `getAvailableProviders`).
* Background sync powered by WorkManager with resumable sessions and incremental updates.
* Token auth with automatic 401 refresh + API key alternative.
* Updated example app with provider picker, invitation code flow, and live sync logs.

## 0.0.9

* Bumped native iOS SDK dependency from `~> 0.3.0` to `~> 0.4.0`.

## 0.0.8

* Bumped native iOS SDK dependency from `~> 0.2.0` to `~> 0.3.0`.

## 0.0.7

* **Breaking:** Replaced the embedded native iOS implementation with the [OpenWearablesHealthSDK](https://cocoapods.org/pods/OpenWearablesHealthSDK) CocoaPod (`~> 0.2.0`). The Flutter plugin is now a thin wrapper around the native iOS SDK.
* All HealthKit logic (authorization, background sync, anchored queries, data serialization, keychain storage) is now handled by the native SDK.
* Health data type authorization now uses the native `HealthDataType` enum instead of raw strings.
* No changes to the public Dart API — existing Flutter integrations continue to work without modification.

## 0.0.6

* Replaced `baseUrl` with required `host` parameter in SDK configuration
* Added refresh token handling with automatic token renewal on 401 errors
* Added invitation code flow support
* Improved sync resilience and error handling
* Removed `customSyncUrl` support

## 0.0.5

* Fixed example app default sync URL to use correct `/api/v1/` base path

## 0.0.4

* Fixed iOS sync endpoint URL - added missing `/api/v1/` prefix

## 0.0.3

* Changed sync endpoint URL from `/sdk/users/{user_id}/sync/apple/healthion` to `/sdk/users/{user_id}/sync/apple`

## 0.0.2

* Added repository and issue tracker URLs for pub.dev

## 0.0.1

* Initial release of Open Wearables Health SDK
* Background health data synchronization from Apple HealthKit (iOS)
* Secure credential storage using iOS Keychain
* Token-based authentication with automatic refresh support
* Incremental sync using anchored queries
* Resumable sync sessions for interrupted uploads
* Support for 40+ health data types including:
  - Activity: steps, distance, flights climbed, walking metrics
  - Heart: heart rate, resting heart rate, HRV, VO2 max
  - Body: weight, height, BMI, body fat percentage
  - Sleep: sleep analysis, mindful sessions
  - Workouts: all workout types with detailed statistics
  - And more...
