import SwiftUI
import CocoaLumberjackSwift

struct TrashDoing: View {
    @StateObject var model: TodoItemModel
    var item: TodoItem
    var body: some View {
        Button {
            DDLogVerbose("\(Date()): Дело \(item.id) было удалено")
            model.remove(id: item.id)
        } label: {
            Image(systemName: "trash")
        }.tint(.red)
        Button {
        }label: {
            Image(systemName: "info.circle")
        }
    }
}
