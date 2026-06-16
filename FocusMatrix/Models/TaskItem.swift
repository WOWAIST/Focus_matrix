import Foundation

struct TaskItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var note: String?
    var isImportant: Bool
    var isUrgent: Bool
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
    var notifyMinutesBefore: Int?
    var autoUpgradedUrgency: Bool

    init(
        title: String,
        note: String? = nil,
        isImportant: Bool,
        isUrgent: Bool,
        dueDate: Date? = nil,
        notifyMinutesBefore: Int? = nil
    ) {
        self.id                  = UUID()
        self.title               = title
        self.note                = note
        self.isImportant         = isImportant
        self.isUrgent            = isUrgent
        self.isCompleted         = false
        self.createdAt           = Date()
        self.updatedAt           = Date()
        self.dueDate             = dueDate
        self.notifyMinutesBefore = notifyMinutesBefore
        self.autoUpgradedUrgency = false
    }
}

enum Quadrant: CaseIterable {
    case doNow, schedule, delegate_, eliminate

    init(isImportant: Bool, isUrgent: Bool) {
        switch (isImportant, isUrgent) {
        case (true, true):   self = .doNow
        case (true, false):  self = .schedule
        case (false, true):  self = .delegate_
        case (false, false): self = .eliminate
        }
    }

    var isImportant: Bool { self == .doNow || self == .schedule }
    var isUrgent: Bool    { self == .doNow || self == .delegate_ }

    var title: String {
        switch self {
        case .doNow:     return "Q1 · Do Now"
        case .schedule:  return "Q2 · Schedule"
        case .delegate_: return "Q3 · Delegate"
        case .eliminate: return "Q4 · Eliminate"
        }
    }

    var subtitle: String {
        switch self {
        case .doNow:     return "Important & Urgent"
        case .schedule:  return "Important, Not Urgent"
        case .delegate_: return "Urgent, Not Important"
        case .eliminate: return "Not Important, Not Urgent"
        }
    }

}
