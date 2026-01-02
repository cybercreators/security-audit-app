# Security Audit App

A native Swift iOS application that performs comprehensive security audits on your device, including jailbreak detection and vulnerability scanning.

## Features

- **Jailbreak Detection**: Identifies common jailbreak indicators and modified system files
- **System Integrity Checks**: Verifies core iOS system files are not compromised
- **Security Settings Audit**: Checks passcode, biometric, and auto-lock settings
- **Network Security Analysis**: Validates SSL/TLS and Wi-Fi encryption
- **App Permissions Review**: Monitors app permissions and background activity
- **Severity Classification**: Color-coded vulnerability levels (Safe, Low, Medium, High, Critical)
- **Scan History**: Tracks security checks over time

## Requirements

- iOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.0 or later
- macOS 12.0 or later (for development)

## Project Structure

```
SecurityAudit/
├── App/
│   └── SecurityAuditApp.swift          # App entry point
├── Views/
│   ├── ContentView.swift               # Tab navigation
│   ├── HomeView.swift                  # Main dashboard
│   ├── ChecksView.swift                # Security checks list
│   ├── CheckDetailView.swift           # Vulnerability details
│   └── SettingsView.swift              # App settings
├── Models/
│   └── SecurityCheck.swift             # Data models
├── Services/
│   └── SecurityChecker.swift           # Security check logic
├── Assets.xcassets                     # App icons and images
└── Info.plist                          # App configuration
```

## Building Locally

### Prerequisites

1. Clone the repository:
```bash
git clone https://github.com/cybercreators/security-audit-app.git
cd security-audit-app
```

2. Open the project in Xcode:
```bash
open SecurityAudit.xcodeproj
```

3. Select a simulator or connected device
4. Press Cmd+B to build
5. Press Cmd+R to run

## Building with Codemagic

This project is configured for automated builds with Codemagic CI/CD.

### Setup Instructions

1. **Connect GitHub Repository**
   - Go to [Codemagic](https://codemagic.io)
   - Connect your GitHub account
   - Select this repository

2. **Configure Build Settings**
   - The `codemagic.yaml` file contains build configurations
   - Two workflows are available:
     - `ios-unsigned-build`: Generates unsigned IPA for distribution
     - `ios-build-and-test`: Runs tests on pull requests

3. **Environment Variables** (Optional for unsigned builds)
   - `DEVELOPER_EMAIL`: Your email for build notifications
   - `APP_STORE_CONNECT_ISSUER_ID`: For signed builds (optional)
   - `APP_STORE_CONNECT_KEY_IDENTIFIER`: For signed builds (optional)
   - `APP_STORE_CONNECT_PRIVATE_KEY`: For signed builds (optional)

4. **Trigger Builds**
   - Push to `main` or `develop` branch to trigger builds
   - Pull requests trigger test builds
   - Unsigned IPAs are available in artifacts

## Unsigned IPA Distribution

The app builds unsigned IPAs that can be distributed for testing without App Store submission.

### Download Unsigned IPA

1. Go to Codemagic build logs
2. Find the completed `ios-unsigned-build` workflow
3. Download the `SecurityAudit-unsigned.ipa` artifact

### Install on Device

**Using Xcode:**
```bash
xcode-select --install  # If needed
xcodebuild -importArchive -archivePath SecurityAudit.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./
```

**Using iOS App Installer:**
- Use third-party tools like Altstore, Sideloadly, or Xcode's Devices window

## Security Checks Performed

### Jailbreak Detection
- Checks for Cydia, Sileo, Zebra installations
- Detects modified system files
- Verifies sandbox integrity
- Identifies suspicious app installations

### System Integrity
- Validates iOS version is current
- Checks system file integrity
- Verifies code signing

### Security Settings
- Passcode/Biometric authentication
- Auto-lock configuration
- Background app refresh settings

### Network Security
- SSL/TLS certificate validation
- VPN configuration status
- Wi-Fi encryption verification

## Privacy

This app performs **all security checks locally on your device**. No data is transmitted to external servers. Your security information remains private and under your control.

## Troubleshooting

### Build Fails in Xcode
- Clean build folder: Cmd+Shift+K
- Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- Update Xcode to latest version

### Codemagic Build Fails
- Check build logs in Codemagic dashboard
- Verify GitHub repository is accessible
- Ensure `codemagic.yaml` is in the root directory
- Check for syntax errors in YAML configuration

### App Crashes on Launch
- Ensure iOS version is 14.0 or later
- Try reinstalling the app
- Check device logs in Xcode

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature/your-feature`
5. Submit a pull request

## License

MIT License - See LICENSE file for details

## Support

For issues, feature requests, or questions:
- Open an issue on GitHub
- Contact: cybercreators@example.com

## Disclaimer

This app is provided for informational purposes. Security checks are not a complete security assessment. Always maintain backups and follow Apple's security guidelines.
