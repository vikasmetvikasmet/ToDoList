import Foundation

protocol NetworkingService {
    func getList() async throws -> [TodoItem]?
    func getTaskById(_ id: String) async throws -> TodoItem? 
    func addTask(_ task: TodoItem) async throws -> TodoItem?
    func updateList(_ tasks: [TodoItem]) async throws -> [TodoItem]?
    func changeTask(_ task: TodoItem) async throws -> TodoItem?
    func deleteTask(_ id: String) async throws
}
