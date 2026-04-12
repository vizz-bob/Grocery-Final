#!/bin/bash

# 🚀 Git Setup Script for Bhejdu Grocery App
# This script sets up Git and pushes to GitHub

set -e

echo "🛒 Git Setup for Bhejdu Grocery App"
echo "====================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install Git first."
    echo "Download: https://git-scm.com/downloads"
    exit 1
fi

print_status "Git version: $(git --version)"

# Initialize Git repository if not already done
if [ ! -d .git ]; then
    print_status "Initializing Git repository..."
    git init
else
    print_warning "Git repository already initialized"
fi

# Configure Git user (if not set)
if [ -z "$(git config --global user.name)" ]; then
    echo "Enter your Git username:"
    read git_username
    git config --global user.name "$git_username"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo "Enter your Git email:"
    read git_email
    git config --global user.email "$git_email"
fi

print_status "Git user: $(git config --global user.name) <$(git config --global user.email)>"

# Add all files
print_status "Adding files to Git..."
git add .

# Commit
print_status "Creating initial commit..."
git commit -m "Initial commit - Bhejdu Grocery App v1.0

Features:
- User authentication (Login, Signup, OTP)
- Product catalog with categories
- Shopping cart with Add to Cart
- Order management and tracking
- Special offers and promotions
- Profile management

Tech Stack:
- Flutter 3.x
- Dart
- PHP/MySQL Backend
- Hostinger Hosting" || print_warning "Nothing to commit or already committed"

# Add remote repository
REMOTE_URL="https://github.com/vizz-bob/Grocery-Final.git"

if git remote | grep -q "origin"; then
    print_warning "Remote 'origin' already exists. Updating..."
    git remote set-url origin "$REMOTE_URL"
else
    print_status "Adding remote repository..."
    git remote add origin "$REMOTE_URL"
fi

print_status "Remote URL: $(git remote get-url origin)"

# Check if GitHub CLI is installed for easier auth
if command -v gh &> /dev/null; then
    print_status "GitHub CLI detected"
    gh auth status || gh auth login
fi

# Push to GitHub
print_status "Pushing to GitHub..."
git branch -M main

# Try to push
if git push -u origin main; then
    print_status "Successfully pushed to GitHub!"
    echo ""
    echo "Repository URL: https://github.com/vizz-bob/Grocery-Final"
else
    print_warning "Push failed. You may need to:"
    echo "1. Authenticate with GitHub"
    echo "2. Create the repository on GitHub first"
    echo "3. Check your internet connection"
    echo ""
    echo "To authenticate, you can:"
    echo "- Use GitHub CLI: gh auth login"
    echo "- Or use HTTPS with Personal Access Token"
    echo "- Or use SSH: git@github.com:vizz-bob/Grocery-Final.git"
fi

echo ""
print_status "Git setup complete! 🎉"
