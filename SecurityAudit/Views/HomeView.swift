import SwiftUI

struct HomeView: View {
    @State private var scanResult: ScanResult?
    @State private var isScanning = false
    @State private var lastScanTime: String = "Never"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Security Audit")
                            .font(.system(size: 32, weight: .bold))
                        Text("Real-time device security checks")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Status Card
                    if let result = scanResult {
                        VStack(spacing: 16) {
                            Text("Overall Status")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(result.overallSeverity == .safe ? "Device Secure" : "Issues Found")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            if result.vulnerabilityCount > 0 {
                                Text("\(result.vulnerabilityCount) issue\(result.vulnerabilityCount > 1 ? "s" : "") found")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)
                        .background(severityColor(result.overallSeverity))
                        .cornerRadius(24)
                    } else {
                        VStack(spacing: 16) {
                            Text("Overall Status")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("No Scan Yet")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)
                        .background(Color.blue)
                        .cornerRadius(24)
                    }
                    
                    // Quick Stats
                    HStack(spacing: 12) {
                        VStack(spacing: 8) {
                            Text("Jailbreak Status")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                            Text("Safe")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                        VStack(spacing: 8) {
                            Text("Last Scan")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                            Text(lastScanTime)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                    
                    // Scan Button
                    Button(action: performScan) {
                        HStack(spacing: 8) {
                            if isScanning {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text(isScanning ? "Scanning..." : "Run Full Scan")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isScanning)
                    
                    // Quick Access
                    VStack(spacing: 12) {
                        Text("Quick Access")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        NavigationLink(destination: ChecksView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Security Checks")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text("View detailed analysis")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Settings")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text("Configure preferences")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Security Audit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func performScan() {
        isScanning = true
        Task {
            let result = await SecurityChecker.shared.performFullScan()
            DispatchQueue.main.async {
                self.scanResult = result
                self.lastScanTime = formatTime(result.timestamp)
                self.isScanning = false
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func severityColor(_ severity: Severity) -> Color {
        switch severity {
        case .safe:
            return .green
        case .low:
            return .blue
        case .medium:
            return .orange
        case .high:
            return .red
        case .critical:
            return Color(red: 0.8, green: 0, blue: 0)
        }
    }
}

#Preview {
    HomeView()
}
