// ─────────────────────────────────────────────────────────────────────────────
// app_config.example.dart  —  Bhejdu Grocery
//
// TEMPLATE FILE — safe to commit.
// Copy this to app_config.dart and fill in your real values.
// app_config.dart is git-ignored so your secrets stay private.
// ─────────────────────────────────────────────────────────────────────────────

class AppConfig {
  // Your Hostinger backend API base URL
  static const String baseUrl = "https://YOUR_HOSTINGER_URL/api";

  // Razorpay key ID (get from Razorpay dashboard)
  static const String razorpayKeyId = "YOUR_RAZORPAY_KEY_ID";

  // App version info
  static const String appVersion = "1.0.0";
}
