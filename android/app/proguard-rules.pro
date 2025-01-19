# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Connectivity Plus Plugin (Added)
-dontwarn io.flutter.plugins.connectivity.**   # Added: Prevent warnings for connectivity_plus plugin
-keep class io.flutter.plugins.connectivity.** { *; }   # Added: Ensure connectivity_plus classes are retained

# Keep annotations and their members
-keep class javax.annotation.** { *; }
-keep class com.google.errorprone.annotations.** { *; }
-keep @javax.annotation.* class * { *; }
-keep class com.google.crypto.tink.** { *; }

# Keep Play Core Library
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google API Client
-keep class com.google.api.** { *; }
-keep class com.google.api.client.** { *; }
-keep class com.google.http.** { *; }

# Keep Google API Client classes
-keep class com.google.api.client.** { *; }
-keep class com.google.http.client.** { *; }

# Keep Joda Time
-keep class org.joda.time.** { *; }

# Keep Joda Time classes
-keep class org.joda.time.** { *; }
-dontwarn org.joda.time.**
-keep class org.joda.convert.** { *; }
-dontwarn org.joda.convert.**

# Keep Apache HTTP classes
-keep class org.apache.http.** { *; }
-dontwarn org.apache.http.**

# Keep SSL classes
-keep class javax.net.ssl.** { *; }
-dontwarn javax.net.ssl.**

# Keep OkHttp classes
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep R8 rules
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Multidex rules
-keep class androidx.multidex.** { *; }

# Keep Split Install
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Additional Keeps
-keep class javax.lang.model.** { *; }
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
