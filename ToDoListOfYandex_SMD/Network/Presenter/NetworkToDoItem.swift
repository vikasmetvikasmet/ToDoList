import Foundation
import CocoaLumberjackSwift

@MainActor
final class TodoItemModel: ObservableObject {
    @Published var todoItems: [TodoItem] = []
    @Published var isLoading = false
    private let defaultNetworkingService = DefaultNetworkingService()
    private var isDirty = false
    let retryManager = RetryManager(retryConfig: RetryCongig(minDelay: 2.0, maxDelay: 120.0, factor: 1.5, jitter: 0.05))
    
    init() {
        Task() {
            await getList()
        }
    }
    @Sendable
    func getList() async {
        do {
            isLoading = true
            let items = try await defaultNetworkingService.getList()
            self.todoItems = items ?? []
            isLoading = false
        } catch {
            isDirty = true
        }
    }
    
    func add(_ item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
        Task{
            do {
                isLoading = true
                if isDirty {
                    try await retryManager.executedWithRetry(operation: getList)
                    isDirty = false
                }
                try await defaultNetworkingService.addTask(item)
                isLoading = false
            } catch {
                isDirty = false
                DDLogVerbose("\(Date()): Ошибка добавления задачи \(error.localizedDescription)")
            }
           
        }
    }
    func updateIsDone(item: TodoItem) -> TodoItem {
        TodoItem(id: item.id,
                 text: item.text,
                 deadline: item.deadline,
                 isDone: !item.isDone,
                 createdAt: item.createdAt,
                 changedAt: item.changedAt,
                 priority: item.priority,
                 color: item.color)
    }
    func updateToDoItem(
        id: String,
        newText: String? = nil,
        newPriority: TodoItem.Priority? = nil,
        newDeadline: Date? = nil,
        newIsDone: Bool? = nil,
        newColor: String?
        
    ) {
        if let index = todoItems.firstIndex(where: { $0.id == id}) {
            var item = todoItems[index]
            item = TodoItem(
                id: item.id,
                text: newText ?? item.text,
                deadline: newDeadline ?? item.deadline,
                isDone: newIsDone ?? item.isDone,
                changedAt: Date(),
                priority: newPriority ?? item.priority,
                color: newColor ?? item.color
            )
            todoItems[index] = item
            Task {[item] in
                do {
                    isLoading = true
                    if isDirty {
                        try await retryManager.executedWithRetry(operation: getList)
                    }
                    try await defaultNetworkingService.changeTask(item)
                    isLoading = false
                } catch{
                    isDirty = true 
                    DDLogVerbose("\(Date()): Ошибка обновления задачи \(error.localizedDescription)")
                }
            }
        }
        
    }
    func remove(id: String) {
        todoItems.removeAll { $0.id == id }
        Task {
            do {
                isLoading = true
                if isDirty {
                    try await retryManager.executedWithRetry(operation: getList)
                    isDirty = false
                }
                try await defaultNetworkingService.deleteTask(id)
                isLoading = false
                
            } catch {
                isDirty = true
                DDLogVerbose("\(Date()): Ошибка удаления задачи \(error.localizedDescription)")
                
            }
        }
    }
    
    private func updateTodoItems(_ tasks: [TodoItem]){
        Task {
            do {
                if let tasks = try await defaultNetworkingService.updateList(tasks) {
                    //TODO:  сделать сохранение в локальное хранилище
                }
                isDirty = false
                //TODO: чистить локальное хранилище
            } catch {
                isDirty = true
            }
        }
    }
    enum sortingTypes{
        case done
        case deadline
        case createdAt
        case priority
    }
    func sortFilters(by: sortingTypes){
        todoItems = todoItems.sorted(by: { oneTodo, twoTodo in
            switch by {
            case .done:
                return oneTodo.isDone && !twoTodo.isDone
            case .deadline:
                return oneTodo.deadline ?? oneTodo.createdAt > twoTodo.deadline ?? twoTodo.createdAt
            case .createdAt:
                return oneTodo.createdAt < twoTodo.createdAt
            case .priority:
                if oneTodo.priority == .high {
                    return true
                } else if twoTodo.priority == .high {
                    return false
                }
                if oneTodo.priority == .normal {
                    return true
                } else if twoTodo.priority == .normal {
                    return false
                }
                return false
            }
        })
    }
}
