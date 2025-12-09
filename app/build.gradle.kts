import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android")
    // لازم يكون Flutter plugin بعد Android و Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.khdooja.taskmate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // تفعيل desugaring لدعم مكتبات Java 8+
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.khdooja.taskmate"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 5        
        versionName = "1.1.2"

    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            val keystoreProperties = Properties()
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = file(keystoreProperties["storeFile"] as String?)
                storePassword = keystoreProperties["storePassword"] as String?
            } else {
                // fallback لو ما في key.properties
                println("⚠️ Warning: key.properties not found, using debug signing config")
            }
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("release") {
            // نستخدم توقيع debug مؤقتًا لتفادي الكراش
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true         
            isShrinkResources = true         
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // لإصلاح مشاكل Desugaring (مهم جدًا)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
