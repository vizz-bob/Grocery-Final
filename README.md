# 🛒 Bhejdu Grocery App

A complete Flutter grocery delivery application with user authentication, product catalog, cart management, and order tracking.

## 📱 Features

- **User Authentication**: Login, Signup, OTP verification, Forgot Password
- **Product Catalog**: Categories, Featured Products, Product Details with Variants
- **Shopping Cart**: Add to cart, Quantity management, Checkout
- **Order Management**: Order history, Order tracking, Order confirmation
- **User Profile**: Profile management, Address management
- **Special Offers**: Promotional banners, Buy 1 Get 1, Discount offers

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point with routes
├── models/
│   └── cart_model.dart          # Cart state management
├── screens/
│   ├── splash_screen.dart       # App splash screen
│   ├── login_page.dart          # User login
│   ├── signup_page.dart         # User registration
│   ├── home_page.dart           # Main home with banners, categories, products
│   ├── categories_page.dart     # All categories listing
│   ├── product_listing_page.dart # Products by category
│   ├── product_variants_page.dart # Product variants/weights
│   ├── cart_page.dart           # Shopping cart
│   ├── checkout_page.dart       # Checkout process
│   ├── orders_page.dart         # Order history
│   ├── order_confirmation_page.dart
│   ├── order_placed_page.dart
│   ├── order_tracking_page.dart
│   ├── profile_page.dart
│   ├── edit_profile_page.dart
│   ├── address_page.dart
│   ├── special_offers_page.dart
│   ├── otp_page.dart
│   ├── forgot_password_page.dart
│   ├── reset_otp_page.dart
│   └── reset_password_page.dart
├── widgets/
│   ├── top_app_bar.dart
│   ├── product_horizontal_card.dart
│   ├── category_tile.dart
│   ├── category_card.dart
│   ├── offer_card.dart
│   ├── banner_slider.dart
│   └── app_drawer.dart
└── theme/
    ├── bhejdu_colors.dart
    └── app_theme.dart
```

## 🚀 Quick Start

### Prerequisites

1. **Flutter SDK** (version 3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (comes with Flutter)

3. **Android Studio** or **VS Code** with Flutter extension

4. **Xcode** (for iOS development on Mac)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/vizz-bob/Grocery-Final.git
   cd Grocery-Final/grocery
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   
   # For specific device
   flutter run -d <device_id>
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0           # API calls
  shared_preferences: ^2.2.2  # Local storage
  image_picker: ^1.0.4   # Image selection
```

## 🌐 API Configuration

The app connects to a PHP/MySQL backend hosted on Hostinger:

- **Base URL**: `https://darkslategrey-chicken-274271.hostingersite.com/api/`
- **API Endpoints**:
  - `login.php` - User login
  - `signup.php` - User registration
  - `get_categories.php` - Fetch categories
  - `get_products.php` - Fetch products by category
  - `get_featured_products.php` - Fetch featured products
  - `get_banners.php` - Fetch promotional banners
  - `get_user.php` - Fetch user profile
  - `place_order.php` - Place new order
  - `get_orders.php` - Fetch order history

## 🚀 Production Deployment

### Step 1: Git Setup

1. **Initialize Git (if not already done)**
   ```bash
   cd /Volumes/traininig/New_Groceryapp_12Apr/doctorapp-20251010T120230Z-1-001/grocery
   git init
   ```

2. **Add all files**
   ```bash
   git add .
   ```

3. **Commit**
   ```bash
   git commit -m "Initial commit - Grocery App v1.0"
   ```

4. **Add remote repository**
   ```bash
   git remote add origin https://github.com/vizz-bob/Grocery-Final.git
   ```

5. **Push to GitHub**
   ```bash
   git branch -M main
   git push -u origin main
   ```

### Step 2: Android Deployment (Play Store)

1. **Update version in `pubspec.yaml`**
   ```yaml
   version: 1.0.0+1
   ```

2. **Update app name and icon**
   - Edit `android/app/src/main/AndroidManifest.xml`
   - Replace launcher icons in `android/app/src/main/res/`

3. **Build APK**
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

4. **Build App Bundle (for Play Store)**
   ```bash
   flutter build appbundle --release
   ```
   Output: `build/app/outputs/bundle/release/app-release.aab`

5. **Sign the app** (first time only)
   - Create keystore:
     ```bash
     keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
     ```
   - Configure signing in `android/app/build.gradle`

6. **Upload to Play Store**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app
   - Upload AAB file
   - Complete store listing
   - Publish

### Step 3: iOS Deployment (App Store)

1. **Update version in Xcode**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner → General → Version

2. **Configure signing**
   - Add Apple Developer account
   - Select Team
   - Set Bundle Identifier (e.g., `com.yourcompany.bhejdu`)

3. **Build for release**
   ```bash
   flutter build ios --release
   ```

4. **Archive and Upload**
   - In Xcode: Product → Archive
   - Distribute App → App Store Connect
   - Upload

5. **Submit to App Store**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Complete app information
   - Submit for review

### Step 4: Web Deployment

1. **Enable web support**
   ```bash
   flutter config --enable-web
   ```

2. **Build for web**
   ```bash
   flutter build web --release
   ```

3. **Deploy to Hostinger (or any hosting)**
   - Upload `build/web/` contents to `public_html/` on Hostinger
   - Or use Firebase Hosting:
     ```bash
     npm install -g firebase-tools
     firebase login
     firebase init
     firebase deploy
     ```

4. **Configure CORS on backend** for web deployment

### Step 5: Backend Deployment

The PHP backend should be hosted on a server with:

1. **PHP 7.4+**
2. **MySQL Database**
3. **SSL Certificate** (HTTPS)

**Database Tables Required:**
- `users` - User accounts
- `categories` - Product categories
- `products` - Product listings
- `product_variants` - Size/weight variants
- `orders` - Order records
- `order_items` - Order details
- `banners` - Promotional banners
- `addresses` - User addresses

## 🔧 Build Commands Reference

```bash
# Development
flutter run                    # Run in debug mode
flutter run -d <device_id>     # Run on specific device
flutter run --hot              # Hot reload enabled

# Testing
flutter test                   # Run tests
flutter test --coverage        # Run tests with coverage

# Building
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS
flutter build web              # Web
flutter build macos            # macOS
flutter build windows          # Windows

# Release (optimized)
flutter build apk --release
flutter build ios --release
flutter build web --release

# Cleaning
flutter clean                  # Clean build cache
flutter pub get                # Reinstall dependencies
```

## 📋 Pre-Deployment Checklist

- [ ] Update app version in `pubspec.yaml`
- [ ] Update app name and description
- [ ] Replace placeholder icons with actual app icons
- [ ] Test on physical devices (not just emulators)
- [ ] Verify API endpoints are accessible
- [ ] Check internet permissions in manifests
- [ ] Enable ProGuard for Android (minification)
- [ ] Test payment flow (if integrated)
- [ ] Review app store guidelines
- [ ] Prepare screenshots for store listing
- [ ] Write app description and keywords
- [ ] Set up privacy policy page

## 🐛 Troubleshooting

**Build Errors:**
```bash
flutter clean
flutter pub get
cd ios && pod install --repo-update
```

**iOS Signing Issues:**
- Open Xcode → Runner → Signing & Capabilities
- Select your team
- Check "Automatically manage signing"

**Android Keystore Issues:**
- Ensure keystore file exists
- Check `android/key.properties` configuration

**API Connection Issues:**
- Verify backend URL is correct
- Check CORS settings on backend
- Test API endpoints with Postman

## 📞 Support

For issues or questions:
- GitHub Issues: https://github.com/vizz-bob/Grocery-Final/issues
- Email: vizz.bob@live.in

## 📄 License

This project is proprietary and confidential.

---

**Happy Coding! 🚀**
