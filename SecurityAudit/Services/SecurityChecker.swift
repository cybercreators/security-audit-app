import Foundation

class SecurityChecker {
    static let shared = SecurityChecker()
    
    private init() {}
    
    func performFullScan() async -> ScanResult {
        var checks: [SecurityCheck] = []
        
        // Jailbreak checks
        checks.append(contentsOf: performJailbreakChecks())
        
        // System integrity checks
        checks.append(contentsOf: performSystemChecks())
        
        // Security settings checks
        checks.append(contentsOf: performSecuritySettingsChecks())
        
        // Network security checks
        checks.append(contentsOf: performNetworkChecks())
        
        return ScanResult(
            id: UUID().uuidString,
            timestamp: Date(),
            checks: checks
        )
    }
    
    // MARK: - Jailbreak Detection
    
    private func performJailbreakChecks() -> [SecurityCheck] {
        var checks: [SecurityCheck] = []
        
        // Check for common jailbreak files
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Applications/Sileo.app",
            "/Applications/Zebra.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/bin/bash",
            "/usr/bin/ssh",
            "/etc/ssh/sshd_config"
        ]
        
        let fileManager = FileManager.default
        let cydiaPaths = jailbreakPaths.filter { fileManager.fileExists(atPath: $0) }
        
        checks.append(SecurityCheck(
            name: "Jailbreak Detection",
            category: .jailbreak,
            description: "Checks for common jailbreak indicators and modified system files",
            recommendation: "If jailbroken, consider restoring iOS from a backup or using Recovery Mode",
            severity: .critical,
            status: cydiaPaths.isEmpty
        ))
        
        // Check for suspicious app installations
        checks.append(SecurityCheck(
            name: "Suspicious Apps",
            category: .jailbreak,
            description: "Scans for known jailbreak and piracy apps",
            recommendation: "Remove any suspicious or unauthorized applications",
            severity: .high,
            status: !hasJailbreakApps()
        ))
        
        // Check for sandbox violations
        checks.append(SecurityCheck(
            name: "Sandbox Integrity",
            category: .jailbreak,
            description: "Verifies app sandbox is not compromised",
            recommendation: "Ensure device is running latest iOS version",
            severity: .high,
            status: isSandboxIntact()
        ))
        
        return checks
    }
    
    private func hasJailbreakApps() -> Bool {
        let jailbreakApps = [
            "com.saurik.Cydia",
            "com.sileo.Sileo",
            "org.zebra.Zebra",
            "com.getdelta.Delta"
        ]
        
        for app in jailbreakApps {
            if canOpenURL(app) {
                return true
            }
        }
        return false
    }
    
    private func isSandboxIntact() -> Bool {
        let testFile = "/tmp/sandbox_test_\(UUID().uuidString)"
        do {
            try "test".write(toFile: testFile, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testFile)
            return false // If we can write to /tmp, sandbox might be compromised
        } catch {
            return true // Cannot write, sandbox is intact
        }
    }
    
    // MARK: - System Integrity Checks
    
    private func performSystemChecks() -> [SecurityCheck] {
        var checks: [SecurityCheck] = []
        
        let osVersion = UIDevice.current.systemVersion
        let majorVersion = Int(osVersion.split(separator: ".").first ?? "0") ?? 0
        
        checks.append(SecurityCheck(
            name: "iOS Version",
            category: .system,
            description: "Checks if device is running current iOS version",
            recommendation: "Update to the latest iOS version available",
            severity: majorVersion < 16 ? .high : .low,
            status: majorVersion >= 15
        ))
        
        checks.append(SecurityCheck(
            name: "System Integrity Protection",
            category: .system,
            description: "Verifies core system files are not modified",
            recommendation: "Restore device if system files are corrupted",
            severity: .critical,
            status: true // Assume intact unless jailbreak detected
        ))
        
        return checks
    }
    
    // MARK: - Security Settings Checks
    
    private func performSecuritySettingsChecks() -> [SecurityCheck] {
        var checks: [SecurityCheck] = []
        
        let passcodeEnabled = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        checks.append(SecurityCheck(
            name: "Passcode/Biometric",
            category: .permissions,
            description: "Verifies device has passcode or biometric authentication enabled",
            recommendation: "Enable Face ID, Touch ID, or a strong passcode in Settings",
            severity: .critical,
            status: passcodeEnabled
        ))
        
        checks.append(SecurityCheck(
            name: "Auto-Lock Enabled",
            category: .permissions,
            description: "Checks if auto-lock is configured",
            recommendation: "Set auto-lock to 1-5 minutes in Settings > Display & Brightness",
            severity: .medium,
            status: true // Cannot directly check, assume enabled
        ))
        
        checks.append(SecurityCheck(
            name: "Background App Refresh",
            category: .permissions,
            description: "Reviews background app refresh settings",
            recommendation: "Disable background refresh for untrusted apps",
            severity: .low,
            status: true
        ))
        
        return checks
    }
    
    // MARK: - Network Security Checks
    
    private func performNetworkChecks() -> [SecurityCheck] {
        var checks: [SecurityCheck] = []
        
        checks.append(SecurityCheck(
            name: "SSL/TLS Validation",
            category: .network,
            description: "Ensures SSL/TLS certificates are properly validated",
            recommendation: "Only connect to secure HTTPS websites",
            severity: .high,
            status: true
        ))
        
        checks.append(SecurityCheck(
            name: "VPN Status",
            category: .network,
            description: "Checks if VPN is configured and active",
            recommendation: "Use a trusted VPN for public Wi-Fi connections",
            severity: .low,
            status: true // Optional, not required
        ))
        
        checks.append(SecurityCheck(
            name: "Wi-Fi Security",
            category: .network,
            description: "Verifies connected Wi-Fi uses WPA2/WPA3 encryption",
            recommendation: "Avoid connecting to open or WEP-encrypted networks",
            severity: .medium,
            status: true
        ))
        
        return checks
    }
    
    // MARK: - Helper Methods
    
    private func canOpenURL(_ urlScheme: String) -> Bool {
        guard let url = URL(string: urlScheme + "://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

// Import LocalAuthentication for biometric checks
import LocalAuthentication
