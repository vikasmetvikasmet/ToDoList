import Foundation

final class DefaultNetworkingService: NetworkingService, ObservableObject {
    
    private let TOKEN = "Firiel"
    private var baseURL = "https://hive.mrdekk.ru/todo"
    private let revisionManager = RevisionManager()
    private let urlSession = URLSession(configuration: .default)
    
    func getList() async throws -> [TodoItem]? {
        guard let request = await createRequest(path: baseURL + "/list", method: "GET") else { throw  NetworkError.requestCreationError }
        return try await makeRequest(request)
    }
    
    func getTaskById(_ id: String) async throws -> TodoItem? {
        guard let request = await createRequest(path: baseURL + "/list/\(id)", method: "GET") else { throw NetworkError.requestCreationError}
        return try await makeRequestForOneElement(request)
    }
    
    func updateList(_ tasks: [TodoItem]) async throws -> [TodoItem]?{
        let serverItems = ServerElementsListRequest(list: tasks.compactMap{ServerTodoItem($0)})
        guard let data = try? JSONEncoder().encode(serverItems),
              let request = await createRequest(path: baseURL + "/list", method: "PATCH", body: data) else {throw NetworkError.requestCreationError}
        return try await makeRequest(request)
    }
    
    func addTask(_ task: TodoItem) async throws -> TodoItem? {
        let serverItem = ServerElementRequest(element: ServerTodoItem(task))
        guard let data = try? JSONEncoder().encode(serverItem),
              let request = await createRequest(path: baseURL + "/list", method: "POST", body: data, withRevision: true) else {throw NetworkError.requestCreationError}
        
        return try await makeRequestForOneElement(request)
    }
    
    func changeTask(_ task: TodoItem) async throws -> TodoItem? {
        let id = task.id
        let serverItem = ServerElementRequest(element: ServerTodoItem(task))
        guard let data = try? JSONEncoder().encode(serverItem),
              let request = await createRequest(path: baseURL + "/list/\(id)", method: "PUT", body: data, withRevision: true) else {throw NetworkError.requestCreationError}
        return try await makeRequestForOneElement(request)
    }
    func deleteTask(_ id: String) async throws {
        guard let request = await createRequest(path: baseURL + "/list/\(id)", method: "DELETE",withRevision: true) else {throw NetworkError.requestCreationError}
        try await makeRequestForOneElement(request)
    }
    
    private func createRequest(path: String,
                               method: String,
                               body: Data? = nil,
                               withRevision: Bool = false) async -> URLRequest? {
        guard let url = URL(string: path) else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(TOKEN)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        
        if withRevision{
            let revision = await revisionManager.getRevision()
            request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        return request
    }
    private func makeRequestForOneElement(_ request: URLRequest) async throws -> TodoItem? {
        do{
            let (data, request) = try await urlSession.dataTask(for: request)
            let item = try? JSONDecoder().decode(ServerElement.self, from: data)
            let serverTodoItem = item?.element
            await revisionManager.updateRevision(Int(item?.revision ?? 0))
            return serverTodoItem?.formTodoItem()
        } catch {
            throw NetworkError.requestExecutionError
        }
        
    }
    private func makeRequest(_ request: URLRequest) async throws -> [TodoItem]? {
        do {
            let (data, request) = try await urlSession.dataTask(for: request)
            let items = try? JSONDecoder().decode(ServerElementsList.self, from: data)
            let serverTodoItems = items?.list
            await revisionManager.updateRevision(Int(items?.revision ?? 0))
            return serverTodoItems?.compactMap{$0.formTodoItem()}
        }catch {
            throw NetworkError.requestExecutionError
        }
    }
}
