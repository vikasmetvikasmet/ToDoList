//
//  FileCache.swift
//  ToDoListOfYandex_SMD
//
//  Created by Vika on 24.06.2024.
//

import Foundation

class FileCatche: ObservableObject {
    @Published private(set) var todoItems: [TodoItem] = []
    var todoListIsEmpty: Bool {
        todoItems.isEmpty
    }
    func add(_ item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
    }
    func remove(id: String) {
        todoItems.removeAll { $0.id == id }
    }
    func save(filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("Failed to get documents directory")
            return
        }
        let jsons: [Any] = todoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsons, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error writing ToDo items to file: \(error.localizedDescription)")
        }
    }
    func load(filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            print("Failed to get documents directory")
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
            for json in jsonArray {
                if let toDoItem = TodoItem.parse(json: json) {
                    todoItems.append(toDoItem)
                }
            }
        } catch {
            print("Error reading ToDo items from file: \(error.localizedDescription)")
        }
        return todoItems
    }
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
