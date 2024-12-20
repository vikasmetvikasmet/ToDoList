import SwiftUI
import CocoaLumberjackSwift

struct CheckmarkDoing: View {
    @StateObject var model: TodoItemModel
    var item: TodoItem
    var body: some View {
        Button {
            DDLogVerbose("\(Date()): У дела \(item.id) изменился статус выполнения на \(!item.isDone)")
            model.updateToDoItem(
                id: item.id,
                newText: item.text,
                newIsDone: !item.isDone,
                newColor: item.color )
        } label: {
            Image(systemName: "checkmark.circle.fill")
        }.tint(.green)
    }
}
