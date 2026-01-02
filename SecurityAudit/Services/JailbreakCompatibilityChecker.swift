import Foundation
import UIKit

struct JailbreakTool: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let website: String
    let supportedVersions: [String]
    let supportedDevices: [String]
    let isCompatible: Bool
    let compatibilityReason: String
    let features: [String]
}

class JailbreakCompatibilityChecker {
    static let shared = JailbreakCompatibilityChecker()
    
    private init() {}
    
    func getDeviceInfo() -> (model: String, osVersion: String, majorVersion: Int, minorVersion: Int) {
        let model = UIDevice.current.model
        let osVersion = UIDevice.current.systemVersion
        let versionComponents = osVersion.split(separator: ".").map { String($0) }
        let majorVersion = Int(versionComponents.first ?? "0") ?? 0
        let minorVersion = Int(versionComponents.indices.contains(1) ? versionComponents[1] : "0") ?? 0
        
        return (model, osVersion, majorVersion, minorVersion)
    }
    
    func checkCompatibility() -> [JailbreakTool] {
        let deviceInfo = getDeviceInfo()
        var tools: [JailbreakTool] = []
        
        // Taurine
        tools.append(checkTaurine(deviceInfo: deviceInfo))
        
        // unc0ver
        tools.append(checkUnc0ver(deviceInfo: deviceInfo))
        
        // Sileo
        tools.append(checkSileo(deviceInfo: deviceInfo))
        
        // Checkra1n
        tools.append(checkCheckra1n(deviceInfo: deviceInfo))
        
        // Palera1n
        tools.append(checkPalera1n(deviceInfo: deviceInfo))
        
        // Dopamine
        tools.append(checkDopamine(deviceInfo: deviceInfo))
        
        return tools
    }
    
    // MARK: - Taurine Compatibility
    
    private func checkTaurine(deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)) -> JailbreakTool {
        // Taurine: iOS 14.0 - 14.3
        let isCompatible = deviceInfo.majorVersion == 14 && deviceInfo.minorVersion <= 3
        
        return JailbreakTool(
            id: "taurine",
            name: "Taurine",
            description: "A jailbreak for iOS 14.0-14.3 supporting A9-A14 devices",
            website: "https://taurine.app",
            supportedVersions: ["14.0", "14.1", "14.2", "14.3"],
            supportedDevices: ["iPhone 6s", "iPhone 7", "iPhone 8", "iPhone X", "iPhone XS", "iPhone XR", "iPhone 11", "iPhone 12"],
            isCompatible: isCompatible,
            compatibilityReason: isCompatible ? "Device supports Taurine" : "iOS version \(deviceInfo.osVersion) not supported. Taurine requires iOS 14.0-14.3",
            features: ["Substrate", "Sileo", "Custom Tweaks", "Themes"]
        )
    }
    
    // MARK: - unc0ver Compatibility
    
    private func checkUnc0ver(deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)) -> JailbreakTool {
        // unc0ver: iOS 11.0 - 14.8
        let isCompatible = deviceInfo.majorVersion >= 11 && deviceInfo.majorVersion <= 14
        
        return JailbreakTool(
            id: "unc0ver",
            name: "unc0ver",
            description: "A jailbreak supporting iOS 11.0-14.8 on A7-A14 devices",
            website: "https://unc0ver.dev",
            supportedVersions: ["11.0", "12.0", "13.0", "14.0", "14.8"],
            supportedDevices: ["iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8", "iPhone X", "iPhone XS", "iPhone XR", "iPhone 11", "iPhone 12"],
            isCompatible: isCompatible,
            compatibilityReason: isCompatible ? "Device supports unc0ver" : "iOS version \(deviceInfo.osVersion) not supported. unc0ver requires iOS 11.0-14.8",
            features: ["Cydia", "Substrate", "Custom Tweaks", "Wide Device Support"]
        )
    }
    
    // MARK: - Sileo Compatibility
    
    private func checkSileo(deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)) -> JailbreakTool {
        // Sileo: Package manager for iOS 12+
        let isCompatible = deviceInfo.majorVersion >= 12
        
        return JailbreakTool(
            id: "sileo",
            name: "Sileo",
            description: "Modern package manager for jailbroken iOS devices (iOS 12+)",
            website: "https://sileo.app",
            supportedVersions: ["12.0", "13.0", "14.0", "15.0", "16.0"],
            supportedDevices: ["iPhone 6s and later", "iPad Air 2 and later"],
            isCompatible: isCompatible,
            compatibilityReason: isCompatible ? "Device supports Sileo" : "iOS version \(deviceInfo.osVersion) not supported. Sileo requires iOS 12.0 or later",
            features: ["Modern UI", "Fast Performance", "Dependency Resolution", "Dark Mode"]
        )
    }
    
    // MARK: - Checkra1n Compatibility
    
    private func checkCheckra1n(deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)) -> JailbreakTool {
        // Checkra1n: Works on A7-A11 devices, iOS 12.3+
        let isCompatible = deviceInfo.majorVersion >= 12
        
        return JailbreakTool(
            id: "checkra1n",
            name: "checkra1n",
            description: "A jailbreak for A7-A11 devices supporting iOS 12.3 and later",
            website: "https://checkra.in",
            supportedVersions: ["12.3", "13.0", "14.0", "15.0", "16.0"],
            supportedDevices: ["iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8", "iPhone X"],
            isCompatible: isCompatible,
            compatibilityReason: isCompatible ? "Device may support checkra1n" : "iOS version \(deviceInfo.osVersion) not supported. checkra1n requires iOS 12.3 or later",
            features: ["Bootrom Exploit", "Wide iOS Support", "Linux/Mac/Windows", "Persistent Jailbreak"]
        )
    }
    
    // MARK: - Palera1n Compatibility
    
    private func checkPalera1n(deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)) -> JailbreakTool {
        // Palera1n: A15+ devices, iOS 15.0+
        let isCompatible = deviceInfo.majorVersion >= 15
        
        return JailbreakTool(
            id: "palera1n",
            name: "palera1n",
            description: "A jailbreak for A15+ devices supporting iOS 15.0 and later",
            website: "https://palera.in",
            supportedVersions: ["15.0", "16.0", "17.0"],
            supportedDevices: ["iPhone 13", "iPhone 13 Pro", "iPhone 13 Pro Max", "iPhone 13 mini", "iPhone 14", "iPhone 14 Pro"],
            isCompatible: isCompatible,
            compatibilityReason: isCompatible ? "Device may support palera1n" : "iOS version \(deviceInfo.osVersion) not supported. palera1n requires iOS 15.0 or later",
            features: ["Semi-Tethered", "A15 Bionic", "Modern iOS Support", "Sileo Integration"]
        )
    }
    
    // MARK: - Dopamine Compatibility
    
    private func checkDopamine(deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)) -> JailbreakTool {
        // Dopamine: iOS 15.0 - 16.6.1
        let isCompatible = (deviceInfo.majorVersion == 15) || (deviceInfo.majorVersion == 16 && deviceInfo.minorVersion <= 6)
        
        return JailbreakTool(
            id: "dopamine",
            name: "Dopamine",
            description: "A jailbreak for iOS 15.0-16.6.1 supporting A12+ devices",
            website: "https://dopamine.sh",
            supportedVersions: ["15.0", "16.0", "16.6.1"],
            supportedDevices: ["iPhone XS", "iPhone XS Max", "iPhone XR", "iPhone 11", "iPhone 12", "iPhone 13", "iPhone 14"],
            isCompatible: isCompatible,
            compatibilityReason: isCompatible ? "Device supports Dopamine" : "iOS version \(deviceInfo.osVersion) not supported. Dopamine requires iOS 15.0-16.6.1",
            features: ["Full Jailbreak", "Sileo Support", "A12+ Devices", "Modern iOS Versions"]
        )
    }
    
    // MARK: - Device Vulnerability Check
    
    func checkBootromVulnerabilities() -> [String] {
        var vulnerabilities: [String] = []
        let deviceModel = UIDevice.current.model
        
        // Checkm8 vulnerability (A7-A11)
        if deviceModel.contains("iPhone") {
            let identifier = getDeviceIdentifier()
            if isA7toA11Device(identifier) {
                vulnerabilities.append("Checkm8 (Bootrom) - A7-A11 devices vulnerable")
            }
        }
        
        return vulnerabilities
    }
    
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private func isA7toA11Device(_ identifier: String) -> Bool {
        let a7to11Devices = [
            "iPhone5s", "iPhone6", "iPhone6Plus", "iPhone6s", "iPhone6sPlus",
            "iPhone7", "iPhone7Plus", "iPhone8", "iPhone8Plus", "iPhoneX"
        ]
        return a7to11Devices.contains { identifier.contains($0) }
    }
}
