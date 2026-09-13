# Flutter embedding
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift / SQLite native
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }
-dontwarn org.sqlite.**

# Mobile scanner / camera
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

# Gson (transitive via some plugins)
-keepattributes Signature
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Play Store splitinstall / deferred components (not used by app)
-dontwarn com.google.android.play.core.**

