-keep class org.drinkless.td.** { *; }
-keep class org.drinkless.tdlib.** { *; }
-keepattributes InnerClasses
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
