# CLAUDE.md

- OWSync (`example/`) ships through dial203/app-store-release: Actions → Ship to App Store Connect,
  repo `dial203_open_wearables_health_sdk`. Every change that will ship bumps `version:` in
  `example/pubspec.yaml` in the same PR: patch for fixes, minor for features. Leave the build number
  after `+` alone; the release workflow sets it.
- The iOS SDK fork is pinned twice: `example/ios/Podfile` (and `Podfile.lock`), which OWSync builds
  with through CocoaPods, and `ios/open_wearables_health_sdk/Package.swift` for SPM. Move both together.
