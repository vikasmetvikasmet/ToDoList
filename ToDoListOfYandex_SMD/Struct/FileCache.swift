import Foundation
import SwiftUI

class FileCatche{
    private(set) var todoItems: [TodoItem] = []
    
    var todoListIsEmpty: Bool {
        todoItems.isEmpty
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
    
    func getItemsFromJSON(fileName: String) throws {
        let jsonData = try getFromJSONFile(fileName: "\(fileName).json")
        let decodedData = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let newItems = decodedData as? [[String: Any]] else { return }
        for todoItem in newItems {
            if let item = TodoItem.parse(json: todoItem) {
                //add(item)
            }
        }
    }
    private func getFromJSONFile(fileName: String) throws -> Data {
        return try Data(contentsOf: getURL(for: fileName))
    }
    private func getURL(for fileName: String) -> URL {
        return getDocumentsDirectoryURL().appendingPathComponent(fileName)
    }
    private func getDocumentsDirectoryURL() -> URL {
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectoryUrl
    }
}
