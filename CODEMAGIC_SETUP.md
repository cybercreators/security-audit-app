# Codemagic Setup Guide - Security Audit App

This guide walks you through setting up automated unsigned IPA builds with Codemagic CI/CD.

## Quick Start (5 minutes)

### Step 1: Connect Codemagic to GitHub

1. Visit https://codemagic.io
2. Click **Sign Up** or **Sign In**
3. Choose **Sign in with GitHub**
4. Authorize Codemagic to access your GitHub account
5. You'll be redirected to your Codemagic dashboard

### Step 2: Add Your Repository

1. Click **Add Application** (or the **+** button)
2. Search for `security-audit-app` in your repositories
3. Select `cybercreators/security-audit-app`
4. Click **Next**

### Step 3: Configure Build Settings

1. You'll see the build configuration screen
2. Select **Codemagic YAML** as the configuration method
3. Codemagic will automatically detect `codemagic.yaml` from your repository
4. Click **Save Configuration**

### Step 4: Start Your First Build

1. Click **Start New Build**
2. Select the `ios-unsigned-build` workflow
3. Choose the `master` branch
4. Click **Build**

Codemagic will now:
- Clone your repository
- Install dependencies
- Build the app for iOS
- Generate an unsigned IPA
- Save artifacts for download

## Automated Builds

Once configured, builds will automatically trigger:

- **On Push**: Every time you push to `main` or `develop` branches
- **On Pull Request**: Test builds run on all pull requests
- **Manual**: You can manually trigger builds from the dashboard

## Downloading Unsigned IPAs

### From Codemagic Dashboard

1. Go to https://codemagic.io
2. Click your project
3. Find the completed build
4. Click **Artifacts**
5. Download `SecurityAudit-unsigned.ipa`

### Command Line

```bash
# List recent builds
codemagic build list --project security-audit-app

# Download latest IPA
codemagic build artifacts download --build-id <BUILD_ID>
```

## Installing Unsigned IPA on Device

### Method 1: Using Xcode (Recommended)

1. Connect your iOS device to Mac
2. Open Xcode
3. Go to **Window** → **Devices and Simulators**
4. Select your device
5. Click the **+** icon under "Installed Apps"
6. Select the unsigned IPA file
7. Click **Open**

### Method 2: Using Altstore

1. Download [Altstore](https://altstore.io)
2. Install Altstore on your Mac
3. Connect iOS device
4. Open Altstore
5. Click **Install IPA**
6. Select the unsigned IPA
7. Enter your Apple ID credentials

### Method 3: Using Sideloadly

1. Download [Sideloadly](https://sideloadly.io)
2. Install on your Mac
3. Connect iOS device
4. Open Sideloadly
5. Drag & drop the IPA
6. Click **Start**

## Environment Variables (Optional)

For advanced features like App Store Connect integration, add these to Codemagic:

1. Go to your project settings
2. Click **Environment Variables**
3. Add these variables:

```
DEVELOPER_EMAIL = your-email@example.com
APP_STORE_CONNECT_ISSUER_ID = (optional)
APP_STORE_CONNECT_KEY_IDENTIFIER = (optional)
APP_STORE_CONNECT_PRIVATE_KEY = (optional)
```

## Troubleshooting

### Build Fails: "Xcode not found"

- Codemagic uses `mac_mini_m1` instance type
- Ensure `xcode: latest` is set in `codemagic.yaml`
- Check build logs for specific errors

### Build Fails: "Pod install failed"

- The app doesn't require CocoaPods by default
- If you add dependencies, run `pod install` locally first
- Commit `Podfile.lock` to your repository

### Build Fails: "Code signing error"

- Unsigned builds don't require code signing
- Verify `CODE_SIGN_IDENTITY=""` in codemagic.yaml
- Check that `PROVISIONING_PROFILE=""` is empty

### IPA Installation Fails

- Ensure iOS device is running iOS 14.0 or later
- Try restarting the device
- Verify the IPA is truly unsigned (not signed with different certificate)
- Check device storage (needs ~100MB free space)

### Build Artifacts Not Available

- Wait for build to complete (usually 5-10 minutes)
- Check build status in Codemagic dashboard
- Verify artifacts section shows files
- Try downloading from browser instead of CLI

## Advanced Configuration

### Custom Build Triggers

Edit `codemagic.yaml` to trigger on specific events:

```yaml
triggering:
  events:
    - push
    - pull_request
    - tag
  branch:
    include:
      - main
      - develop
      - release/*
```

### Scheduled Builds

Add to `codemagic.yaml` to build on schedule:

```yaml
triggering:
  events:
    - push
  branch:
    include:
      - main
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight UTC
```

### Slack Notifications

Add to `codemagic.yaml`:

```yaml
publishing:
  slack:
    channel: '#builds'
    notify_on_build_start: true
    notify:
      success: true
      failure: true
```

### GitHub Releases

The current `codemagic.yaml` already publishes to GitHub Releases:

```yaml
publishing:
  github_releases:
    release: true
    files:
      - $XCODE_SCHEME-unsigned.ipa
```

## Testing Locally Before Codemagic

### Build Unsigned IPA Locally

```bash
cd /path/to/security-audit-app

# Clean build
xcodebuild clean

# Build for iOS
xcodebuild build \
  -project SecurityAudit.xcodeproj \
  -scheme SecurityAudit \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath build \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO

# Create IPA
mkdir -p Payload
cp -r build/Release-iphoneos/SecurityAudit.app Payload/
zip -r SecurityAudit-unsigned.ipa Payload/
rm -rf Payload
```

## Monitoring Builds

### Real-time Logs

1. Go to Codemagic dashboard
2. Click your project
3. Select a build
4. Watch logs update in real-time

### Build History

1. Click **Builds** tab
2. See all past builds
3. Filter by branch or status
4. Click any build for details

### Metrics

1. Go to project **Settings**
2. Click **Metrics**
3. View build times, success rates, and trends

## Next Steps

- **Customize**: Modify `codemagic.yaml` for your needs
- **Test**: Install IPA on test device
- **Share**: Distribute unsigned IPA to testers
- **Iterate**: Push updates to trigger new builds
- **Monitor**: Watch build logs and metrics

## Support

For Codemagic issues:
- Visit https://codemagic.io/docs
- Check build logs for error details
- Contact Codemagic support

For app issues:
- Check GitHub Issues: https://github.com/cybercreators/security-audit-app/issues
- Review README.md for troubleshooting
