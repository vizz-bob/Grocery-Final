#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# git-push-secure.sh  —  Bhejdu Grocery
# Run this once from Terminal to commit and push the security updates.
# ─────────────────────────────────────────────────────────────────────────────

set -e

cd "$(dirname "$0")"

echo "🔓 Removing any stale git lock..."
rm -f .git/index.lock

echo "📋 Staging security files..."
git add .gitignore lib/config/app_config.example.dart

echo "💾 Committing..."
git commit -m "security: update .gitignore and add app_config template

- Expanded .gitignore: covers .env, Firebase, Razorpay keys, iOS signing,
  CocoaPods, keystore, test scripts, and macOS junk files
- Added lib/config/app_config.example.dart as safe public template
- Real app_config.dart (with live URL + keys) is now git-ignored
- insert_test_user.php is now git-ignored"

echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Done! Changes pushed to https://github.com/vizz-bob/Grocery-Final"
echo ""
echo "⚠️  NEXT STEP: Replace hardcoded URLs in your dart files with AppConfig.baseUrl"
echo "   Example: import 'package:grocery/config/app_config.dart';"
echo "            Uri.parse(\"\${AppConfig.baseUrl}/your_endpoint.php\")"
