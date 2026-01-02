import SwiftUI

struct SettingsView: View {
    @State private var autoScanEnabled = false
    @State private var notificationsEnabled = true
    @State private var scanInterval = 24
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Scan Settings")) {
                    Toggle("Enable Auto-Scan", isOn: $autoScanEnabled)
                    
                    if autoScanEnabled {
                        Picker("Scan Interval", selection: $scanInterval) {
                            Text("Every 6 hours").tag(6)
                            Text("Every 12 hours").tag(12)
                            Text("Every 24 hours").tag(24)
                            Text("Weekly").tag(168)
                        }
                    }
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Security Alerts", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        Text("Receive notifications for critical vulnerabilities")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("iOS Version")
                        Spacer()
                        Text(UIDevice.current.systemVersion)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Device Model")
                        Spacer()
                        Text(UIDevice.current.model)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Privacy & Security")) {
                    NavigationLink(destination: PrivacyView()) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsView()) {
                        Text("Terms of Service")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.system(size: 24, weight: .bold))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Data Collection")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Security Audit collects device security information locally on your device. No data is sent to external servers.")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(2)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Local Processing")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("All security checks are performed locally on your device. Your security information is never shared with third parties.")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(2)
                }
                
                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms of Service")
                    .font(.system(size: 24, weight: .bold))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Usage")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("This app is provided as-is for security auditing purposes. The security checks are informational and should not be considered a complete security assessment.")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(2)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Disclaimer")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("We are not responsible for any damage or data loss resulting from the use of this application. Always maintain backups of your important data.")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(2)
                }
                
                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
