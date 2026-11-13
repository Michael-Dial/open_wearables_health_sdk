plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Google Play: the "Ship to Google Play" workflow in Michael-Dial/app-store-release puts this app's
// upload key on the runner and names it in these variables. Without them (a local
// `flutter run --release`) the release build signs with the debug key, which Play refuses.
val uploadKeystore: String? = System.getenv("ANDROID_UPLOAD_KEYSTORE")?.takeIf { it.isNotBlank() }

android {
    namespace = "com.openwearables.health.sdk.example"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // OWSync's ID, the same as its iOS bundle ID. The namespace above only names the generated
        // classes (and MainActivity's package) and need not match.
        applicationId = "com.dial203.owsync"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 29
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        uploadKeystore?.let { path ->
            create("upload") {
                storeFile = file(path)
                storePassword = System.getenv("ANDROID_UPLOAD_STORE_PASSWORD")
                keyAlias = System.getenv("ANDROID_UPLOAD_KEY_ALIAS")
                keyPassword = System.getenv("ANDROID_UPLOAD_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("upload") ?: signingConfigs.getByName("debug")
            
            // Enable R8/ProGuard
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
