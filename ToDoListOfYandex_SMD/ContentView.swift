//
//  ContentView.swift
//  ToDoListOfYandex_SMD
//
//  Created by Vika on 19.06.2024.
//

import SwiftUI
import Foundation

struct TodoItem: Codable {
    let id: String
    let text: String
    let deadline: Date?
    let taskDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    let priority: Priority
    enum Priority: String, Codable {
        case low = "неважная"
        case normal = "обычная"
        case high = "важная"
    }
    init(
        id: String?,
        text: String,
        deadline: Date?,
        taskDone: Bool,
        creationDate: Date = Date(),
        modificationDate: Date?,
        priority: Priority
    ) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.deadline = deadline
        self.taskDone = taskDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.priority = priority
    }

}

extension TodoItem {
    var json: Any {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["text"] = text
        jsonDict["deadline"] = deadline
        jsonDict["taskDone"] = taskDone
        jsonDict["creationDate"] = creationDate
        jsonDict["modificationDate"] = modificationDate?.timeIntervalSince1970
        if priority != .normal {
            jsonDict["priority"] = priority
        }
        return jsonDict
    }
    func creation(jsonDict: Any) -> String? {
        do {
            let encoder = JSONEncoder()
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            let jsonString: String? = String(data: data)
            print(jsonString ?? "JSON string is nil")
            return jsonString ?? "JSON string is nil"
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
}
    static func parse(json: Any) -> TodoItem? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let todoItem = try decoder.decode(TodoItem.self, from: jsonData)
            return todoItem
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
    }
}

class FileCatch {
    private var todoItems: [TodoItem] = []
    private let filename: String

        init(filename: String) {
            self.filename = filename
            self.todoItems = []
            loadTodoItems()
        }

        func getAllTodoItems() -> [TodoItem] {
            return todoItems
        }

        func addTodoItem(_ item: TodoItem) {
            if !todoItems.contains(where: { $0.id == item.id }) {
                todoItems.append(item)
                saveTodoItems()
            }
        }

        func removeTodoItem(withId id: String) {
            todoItems.removeAll { $0.id == id }
            saveTodoItems()
        }

        private func saveTodoItems() {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(todoItems)
                try data.write(to: fileURL())
            } catch {
                print("Error saving todo items: \(error)")
            }
        }

        private func loadTodoItems() {
            do {
                let data = try Data(contentsOf: fileURL())
                let decoder = JSONDecoder()
                todoItems = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error loading todo items: \(error)")
            }
        }
        private func fileURL() -> URL {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsDirectory.appendingPathComponent(filename)
        }
    func addTodoItem(item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
    }
}
