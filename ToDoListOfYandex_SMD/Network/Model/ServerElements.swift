import Foundation

struct ServerElementsListRequest: Codable {
    let list: [ServerTodoItem]
}

struct ServerElementRequest: Codable {
    let element: ServerTodoItem
}

struct ServerElementsList: Codable {
    let status: String
    let list: [ServerTodoItem]
    let revision: Int
}

struct ServerElement: Codable {
    let status: String
    let element: ServerTodoItem
    let revision: Int
}
