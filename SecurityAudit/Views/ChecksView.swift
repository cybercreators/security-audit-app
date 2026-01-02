import SwiftUI

struct ChecksView: View {
    @State private var scanResult: ScanResult?
    @State private var selectedCheck: SecurityCheck?
    @State private var isScanning = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let result = scanResult {
                        VStack(spacing: 12) {
                            ForEach(result.checks) { check in
                                NavigationLink(destination: CheckDetailView(check: check)) {
                                    CheckRowView(check: check)
                                }
                            }
                        }
                        .padding(16)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            
                            Text("No Scan Results")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("Run a scan from the Home tab to see security checks")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Button(action: performScan) {
                                Text("Run Scan Now")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(24)
                    }
                }
            }
            .navigationTitle("Security Checks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isScanning {
                        ProgressView()
                    } else {
                        Button(action: performScan) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .onAppear {
                if scanResult == nil {
                    performScan()
                }
            }
        }
    }
    
    private func performScan() {
        isScanning = true
        Task {
            let result = await SecurityChecker.shared.performFullScan()
            DispatchQueue.main.async {
                self.scanResult = result
                self.isScanning = false
            }
        }
    }
}

struct CheckRowView: View {
    let check: SecurityCheck
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: check.status ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(check.status ? .green : severityColor(check.severity))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(check.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(check.category.rawValue.capitalized)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(check.severity.rawValue.capitalized)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(severityColor(check.severity))
                .cornerRadius(4)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
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
            return Color(red: 1, green: 0.5, blue: 0)
        case .critical:
            return .red
        }
    }
}

#Preview {
    ChecksView()
}
