import SwiftUI

struct JailbreakCompatibilityView: View {
    @State private var compatibleTools: [JailbreakTool] = []
    @State private var isLoading = true
    @State private var selectedTool: JailbreakTool?
    @State private var deviceInfo: (model: String, osVersion: String, majorVersion: Int, minorVersion: Int)?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Device Info Card
                    if let info = deviceInfo {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Device Information")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Model")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(info.model)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                
                                HStack {
                                    Text("iOS Version")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(info.osVersion)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .padding(16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Compatibility Summary
                    let compatibleCount = compatibleTools.filter { $0.isCompatible }.count
                    VStack(spacing: 12) {
                        Text("Jailbreak Compatibility")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 12) {
                            VStack(spacing: 4) {
                                Text("Compatible")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                                Text("\(compatibleCount)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            
                            VStack(spacing: 4) {
                                Text("Total")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                                Text("\(compatibleTools.count)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Jailbreak Tools List
                    VStack(spacing: 12) {
                        Text("Available Jailbreak Tools")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(compatibleTools) { tool in
                                NavigationLink(destination: JailbreakToolDetailView(tool: tool)) {
                                    JailbreakToolRowView(tool: tool)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(16)
            }
            .navigationTitle("Jailbreak Compatibility")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadCompatibilityData()
            }
        }
    }
    
    private func loadCompatibilityData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let checker = JailbreakCompatibilityChecker.shared
            deviceInfo = checker.getDeviceInfo()
            compatibleTools = checker.checkCompatibility()
            isLoading = false
        }
    }
}

struct JailbreakToolRowView: View {
    let tool: JailbreakTool
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(tool.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if tool.isCompatible {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 14))
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }
                }
                
                Text(tool.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct JailbreakToolDetailView: View {
    let tool: JailbreakTool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(tool.name)
                            .font(.system(size: 28, weight: .bold))
                        
                        Spacer()
                        
                        if tool.isCompatible {
                            VStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                Text("Compatible")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                        } else {
                            VStack(spacing: 4) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.red)
                                Text("Not Compatible")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Text(tool.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                // Compatibility Info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Compatibility Status")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(tool.compatibilityReason)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Supported Versions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Supported iOS Versions")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(tool.supportedVersions, id: \.self) { version in
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12, weight: .semibold))
                                Text(version)
                                    .font(.system(size: 14, weight: .regular))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Supported Devices
                VStack(alignment: .leading, spacing: 12) {
                    Text("Supported Devices")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(tool.supportedDevices, id: \.self) { device in
                            HStack {
                                Image(systemName: "iphone")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 12))
                                Text(device)
                                    .font(.system(size: 14, weight: .regular))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Features")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(tool.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 12))
                                Text(feature)
                                    .font(.system(size: 14, weight: .regular))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                // Website Link
                Link(destination: URL(string: tool.website) ?? URL(string: "https://apple.com")!) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                        Text("Visit Official Website")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(.blue)
                            .font(.system(size: 12))
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Tool Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    JailbreakCompatibilityView()
}
