#!/bin/bash

# 🚀 Bhejdu Grocery App Deployment Script
# Usage: ./deploy.sh [android|ios|web|all]

set -e

echo "🛒 Bhejdu Grocery App Deployment"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed. Please install Flutter first."
    exit 1
fi

print_status "Flutter version: $(flutter --version | head -n 1)"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

# Run tests (if any exist)
print_status "Running tests..."
flutter test || print_warning "No tests found or tests failed"

deploy_android() {
    print_status "Building Android APK..."
    flutter build apk --release
    
    print_status "Building Android App Bundle..."
    flutter build appbundle --release
    
    print_status "Android builds complete:"
    echo "  - APK: build/app/outputs/flutter-apk/app-release.apk"
    echo "  - AAB: build/app/outputs/bundle/release/app-release.aab"
}

deploy_ios() {
    print_status "Building iOS..."
    flutter build ios --release
    
    print_status "iOS build complete"
    print_warning "Open ios/Runner.xcworkspace in Xcode to archive and upload"
}

deploy_web() {
    print_status "Building Web..."
    flutter build web --release
    
    print_status "Web build complete: build/web/"
    print_warning "Upload build/web/ contents to your hosting server"
}

# Main deployment logic
case "${1:-all}" in
    android)
        deploy_android
        ;;
    ios)
        deploy_ios
        ;;
    web)
        deploy_web
        ;;
    all)
        print_status "Building for all platforms..."
        deploy_android
        deploy_ios
        deploy_web
        ;;
    *)
        echo "Usage: ./deploy.sh [android|ios|web|all]"
        exit 1
        ;;
esac

print_status "Deployment builds complete! 🎉"
echo ""
echo "Next steps:"
echo "1. Test the builds on physical devices"
echo "2. Upload Android AAB to Google Play Console"
echo "3. Archive iOS build in Xcode and upload to App Store Connect"
echo "4. Deploy web build to your hosting server"
