# 🚀 Complete Deployment Guide - Bhejdu Grocery App

## Table of Contents
1. [Git Setup & GitHub](#1-git-setup--github)
2. [Android Deployment](#2-android-deployment)
3. [iOS Deployment](#3-ios-deployment)
4. [Web Deployment](#4-web-deployment)
5. [Backend Configuration](#5-backend-configuration)
6. [Post-Deployment Checklist](#6-post-deployment-checklist)

---

## 1. Git Setup & GitHub

### Quick Setup (Automated)
```bash
cd /Volumes/traininig/New_Groceryapp_12Apr/doctorapp-20251010T120230Z-1-001/grocery
./git-setup.sh
```

### Manual Setup

#### Step 1.1: Initialize Git
```bash
cd /Volumes/traininig/New_Groceryapp_12Apr/doctorapp-20251010T120230Z-1-001/grocery
git init
```

#### Step 1.2: Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### Step 1.3: Add Files
```bash
git add .
```

#### Step 1.4: Commit
```bash
git commit -m "Initial commit - Bhejdu Grocery App v1.0"
```

#### Step 1.5: Add Remote Repository
```bash
git remote add origin https://github.com/vizz-bob/Grocery-Final.git
```

#### Step 1.6: Push to GitHub
```bash
git branch -M main
git push -u origin main
```

**Repository URL**: https://github.com/vizz-bob/Grocery-Final

---

## 2. Android Deployment

### Prerequisites
- Android Studio
- Keystore file (for signing)
- Google Play Developer account ($25 one-time fee)

### Step 2.1: Update Version
Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

### Step 2.2: Update App Icon
Replace icons in:
- `android/app/src/main/res/mipmap-hdpi/`
- `android/app/src/main/res/mipmap-mdpi/`
- `android/app/src/main/res/mipmap-xhdpi/`
- `android/app/src/main/res/mipmap-xxhdpi/`
- `android/app/src/main/res/mipmap-xxxhdpi/`

### Step 2.3: Update App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Bhejdu Grocery"
    ... >
```

### Step 2.4: Create Keystore (First Time Only)
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Create file `android/key.properties`:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/Users/yourusername/upload-keystore.jks
```

### Step 2.5: Build Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Step 2.6: Build App Bundle (For Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 2.7: Upload to Google Play Console
1. Go to https://play.google.com/console
2. Click "Create app"
3. Fill in app details:
   - App name: Bhejdu Grocery
   - Default language: English
   - App category: Shopping
4. Upload AAB file
5. Complete store listing:
   - Short description (80 chars)
   - Full description (4000 chars)
   - Screenshots (phone, tablet)
   - Feature graphic
   - App icon
6. Set up pricing and distribution
7. Publish

---

## 3. iOS Deployment

### Prerequisites
- Mac with Xcode
- Apple Developer account ($99/year)
- Physical iOS device for testing

### Step 3.1: Update Version
Open `ios/Runner.xcworkspace` in Xcode:
- Select Runner → General → Version: 1.0.0
- Build: 1

### Step 3.2: Configure Signing
1. Xcode → Runner → Signing & Capabilities
2. Select your Team
3. Check "Automatically manage signing"
4. Set Bundle Identifier: `com.yourcompany.bhejdu`

### Step 3.3: Update App Icon
Use Xcode Asset Catalog:
- Open `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- Replace with your app icons

### Step 3.4: Build for Release
```bash
flutter build ios --release
```

### Step 3.5: Archive and Upload
1. In Xcode: Product → Scheme → Edit Scheme
   - Set Build Configuration to "Release"
2. Product → Destination → Any iOS Device
3. Product → Archive
4. Distribute App → App Store Connect → Upload

### Step 3.6: Submit to App Store
1. Go to https://appstoreconnect.apple.com
2. Select your app
3. Complete app information:
   - App Preview and Screenshots
   - Promotional Text
   - Description
   - Keywords
   - Support URL
   - Marketing URL
4. Fill in App Review Information
5. Submit for Review

---

## 4. Web Deployment

### Step 4.1: Enable Web Support
```bash
flutter config --enable-web
```

### Step 4.2: Build for Web
```bash
flutter build web --release
```

### Step 4.3: Deploy to Hostinger
1. Log in to Hostinger control panel
2. Go to File Manager
3. Navigate to `public_html/`
4. Upload all files from `build/web/`
5. Ensure `index.html` is in the root

### Alternative: Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy
```

### Step 4.4: Configure CORS (Important!)
Add to your PHP backend (`api/.htaccess` or PHP files):
```php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
```

---

## 5. Backend Configuration

### Current Backend Setup
- **Hosting**: Hostinger
- **URL**: https://darkslategrey-chicken-274271.hostingersite.com/
- **Type**: PHP/MySQL

### Required Database Tables

#### users
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### categories
```sql
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50),
    total_items INT DEFAULT 0
);
```

#### products
```sql
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(500),
    description TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

#### product_variants
```sql
CREATE TABLE product_variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    size VARCHAR(50),
    price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

#### orders
```sql
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### order_items
```sql
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);
```

### API Endpoints Structure
```
/api/
├── login.php
├── signup.php
├── get_user.php
├── get_categories.php
├── get_products.php
├── get_featured_products.php
├── get_banners.php
├── place_order.php
├── get_orders.php
└── uploads/
```

---

## 6. Post-Deployment Checklist

### Before Going Live

#### Functionality Tests
- [ ] User can register
- [ ] User can login
- [ ] User can view categories
- [ ] User can view products
- [ ] User can add to cart
- [ ] User can checkout
- [ ] User can view orders
- [ ] User can track orders
- [ ] Special offers work
- [ ] Profile page loads

#### Performance Tests
- [ ] App loads within 3 seconds
- [ ] Images load properly
- [ ] No memory leaks
- [ ] Smooth scrolling
- [ ] Fast API responses

#### Security Checks
- [ ] HTTPS enabled on backend
- [ ] API authentication working
- [ ] No hardcoded secrets
- [ ] Input validation on backend
- [ ] SQL injection prevention

#### Store Requirements
- [ ] App icon (all sizes)
- [ ] Screenshots (phone + tablet)
- [ ] Feature graphic (Android)
- [ ] Privacy policy URL
- [ ] Support email/URL
- [ ] App description
- [ ] Keywords for search

#### Legal
- [ ] Privacy policy page
- [ ] Terms of service
- [ ] Cookie policy (for web)
- [ ] GDPR compliance (if applicable)

---

## 📞 Support & Resources

### Documentation
- Flutter: https://docs.flutter.dev
- Dart: https://dart.dev/guides
- Android: https://developer.android.com/studio/publish
- iOS: https://developer.apple.com/app-store/submissions

### Help
- GitHub Issues: https://github.com/vizz-bob/Grocery-Final/issues
- Email: vizz.bob@live.in

### Useful Commands
```bash
# Quick build all
./deploy.sh all

# Only Android
./deploy.sh android

# Only iOS
./deploy.sh ios

# Only Web
./deploy.sh web

# Git setup
./git-setup.sh
```

---

**Good luck with your deployment! 🚀**
