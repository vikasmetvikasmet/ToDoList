import Foundation

extension TodoItem {
    var json: Any {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["text"] = text
        jsonDict["importance"] = priority.rawValue
        if let deadline = deadline {
            jsonDict["deadline"] = deadline.timeIntervalSince1970
        }
        jsonDict["done"] = isDone
        jsonDict["color"] = color
        jsonDict["created_at"] = Int(changedAt?.timeIntervalSince1970 ??  Date().timeIntervalSince1970)
        jsonDict["changed_at"] = Int(changedAt?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        jsonDict["last_updated_by"] = ""
        return jsonDict
    }
    static func parse(json: Any) -> TodoItem? {
        guard let todoItem = json as? [String: Any],
              let id = todoItem["id"] as? String,
              let text: String = todoItem["text"] as? String,
              let isDone = todoItem["done"] as? Bool,
              let color = todoItem["color"] as? String
                
                
        else {return nil}
        
        var deadline: Date?
        if let unwrappedDeadline = todoItem["deadline"] as? Int {
            deadline = Date(timeIntervalSince1970: TimeInterval(unwrappedDeadline))
        }
        var priority: Priority?
        if let changeImportance = todoItem["importance"] as? String {
            priority = Priority(rawValue: changeImportance.lowercased())
        }
        var changedAt: Date?
        if let unwrappedModificationDate = todoItem["changed_at"] as? Int {
            changedAt = Date(timeIntervalSince1970: TimeInterval(unwrappedModificationDate))
        }
        var createdAt: Date?
        if let changeCreatedAt = todoItem["created_at"] as? Int {
            createdAt = Date(timeIntervalSince1970: TimeInterval(changeCreatedAt))
        }
        
        let toDoItem = TodoItem(id: id, text: text, deadline: deadline, isDone: isDone, createdAt: createdAt ?? Date(), changedAt: changedAt, priority: priority ?? .normal, color: color)
        return toDoItem
    }
}
