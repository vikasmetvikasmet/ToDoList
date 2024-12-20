import Foundation
import SwiftUI

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let changedAt: Date?
    let priority: Priority
    let color: String
    
    enum Priority: String {
        case high = "important"
        case normal = "basic"
        case low = "low"
    }
    init(
        id: String = UUID().uuidString,
        text: String,
        deadline: Date?,
        isDone: Bool = false,
        createdAt: Date = Date(),
        changedAt: Date? = nil,
        priority: Priority = .normal,
        color: String = ""
    ) {
        self.id = id
        self.text = text
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.priority = priority
        self.color = color
    }
}
