import Foundation

struct ServerTodoItem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int64?
    let done: Bool
    let color: String
    let created_at: Int64
    let changed_at: Int64
    let last_updated_by: String
    
    init(_ todoItem: TodoItem) {
        let creationDate = ServerTodoItem.getUnixTimestampFromDate(todoItem.createdAt) ?? 0
        self.id = todoItem.id
        self.text = todoItem.text
        self.importance = ServerTodoItem.getStringFromTaskImportance(todoItem.priority)
        self.deadline = ServerTodoItem.getUnixTimestampFromDate(todoItem.deadline)
        self.done = todoItem.isDone
        self.color = todoItem.color
        self.created_at = creationDate
        self.changed_at = ServerTodoItem.getUnixTimestampFromDate(todoItem.changedAt) ?? creationDate
        self.last_updated_by = ""
    }
    
    func formTodoItem() -> TodoItem? {
        guard let createdAt = getFormatDateFromUnixTimestamp(created_at),
              let changedAt = getFormatDateFromUnixTimestamp(changed_at) else {return nil}
        return TodoItem(id: id, text: text, deadline: getFormatDateFromUnixTimestamp(deadline), isDone: done, createdAt: createdAt, changedAt: changedAt, priority: TodoItem.Priority(rawValue: importance) ?? TodoItem.Priority.normal, color: color)
        
    }
    private func getFormatDateFromUnixTimestamp(_ unixTimestamp: Int64?) -> Date? {
        if let dateTime = unixTimestamp {
            return Date(timeIntervalSince1970: TimeInterval(dateTime))
        }else {
            return nil
        }
    }
    static private func getUnixTimestampFromDate(_ date: Date?) -> Int64? {
        guard let timeInterval = date?.timeIntervalSince1970 else {
            return nil
        }
        return Int64(timeInterval)
    }
    
    static private func getStringFromTaskImportance(_ taskImportance: TodoItem.Priority) -> String {
        switch taskImportance {
        case .low:
            return "low"
        case .normal:
            return "basic"
        case .high:
            return "important"
        }
    }
}
