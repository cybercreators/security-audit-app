import SwiftUI

struct CheckDetailView: View {
    let check: SecurityCheck
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Status Header
                HStack(spacing: 12) {
                    Image(systemName: check.status ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(check.status ? .green : severityColor(check.severity))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(check.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(check.status ? "Passed" : "Failed")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(check.status ? .green : .red)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Severity Badge
                HStack(spacing: 12) {
                    Text("Severity Level")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(check.severity.rawValue.uppercased())
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(severityColor(check.severity))
                        .cornerRadius(6)
                }
                
                // Category
                HStack(spacing: 12) {
                    Text("Category")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(check.category.rawValue.capitalized)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Divider()
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(check.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(2)
                }
                
                Divider()
                
                // Recommendation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recommendation")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(check.recommendation)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(2)
                }
                
                Divider()
                
                // Timestamp
                HStack(spacing: 12) {
                    Text("Last Checked")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatDate(check.timestamp))
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Check Details")
        .navigationBarTitleDisplayMode(.inline)
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    CheckDetailView(check: SecurityCheck(
        name: "Jailbreak Detection",
        category: .jailbreak,
        description: "Checks for common jailbreak indicators",
        recommendation: "If jailbroken, restore iOS",
        severity: .critical,
        status: true
    ))
}
