import SwiftUI
import CocoaLumberjackSwift

struct CircleDoing: View {
    var item: TodoItem
    @StateObject var model: TodoItemModel
    var body: some View {
        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(item.isDone ? .green : (item.priority == .high ? .red : .gray))
            .background(
                Circle()
                    .fill(item.priority == .high ? .red.opacity(0.1) : .clear)
            )
            .gesture(
                TapGesture().onEnded {
                    DDLogVerbose("\(Date()): У дела \(item.id) изменился статус выполнения на \(!item.isDone)")
                    model.updateToDoItem(
                        id: item.id,
                        newText: item.text,
                        newIsDone: !item.isDone,
                        newColor: item.color )
                }
            )
            .padding(.trailing, 7)
    }
}
