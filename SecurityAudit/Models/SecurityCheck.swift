import Foundation

enum Severity: String, Codable {
    case safe = "safe"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var color: String {
        switch self {
        case .safe:
            return "#22C55E"
        case .low:
            return "#3B82F6"
        case .medium:
            return "#F59E0B"
        case .high:
            return "#F97316"
        case .critical:
            return "#EF4444"
        }
    }
}

enum CheckCategory: String, Codable {
    case jailbreak = "jailbreak"
    case system = "system"
    case permissions = "permissions"
    case network = "network"
}

struct SecurityCheck: Identifiable, Codable {
    let id: String
    let name: String
    let category: CheckCategory
    let description: String
    let recommendation: String
    var severity: Severity
    var status: Bool // true = passed, false = failed
    let timestamp: Date
    
    init(
        id: String = UUID().uuidString,
        name: String,
        category: CheckCategory,
        description: String,
        recommendation: String,
        severity: Severity = .low,
        status: Bool = false,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.recommendation = recommendation
        self.severity = severity
        self.status = status
        self.timestamp = timestamp
    }
}

struct ScanResult: Identifiable, Codable {
    let id: String
    let timestamp: Date
    var checks: [SecurityCheck]
    
    var overallSeverity: Severity {
        if checks.contains(where: { $0.severity == .critical && !$0.status }) {
            return .critical
        } else if checks.contains(where: { $0.severity == .high && !$0.status }) {
            return .high
        } else if checks.contains(where: { $0.severity == .medium && !$0.status }) {
            return .medium
        } else if checks.contains(where: { !$0.status }) {
            return .low
        }
        return .safe
    }
    
    var vulnerabilityCount: Int {
        checks.filter { !$0.status }.count
    }
}
