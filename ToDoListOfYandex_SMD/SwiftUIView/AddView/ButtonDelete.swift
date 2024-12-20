import SwiftUI
import CocoaLumberjackSwift

struct ButtonDelete: View {
    @StateObject var model: TodoItemModel
    var selectedItem: TodoItem?
    var parentDismiss: DismissAction
    var body: some View {
        Section {
            HStack {
                Spacer()
                Button("Удалить") {
                    if let item = selectedItem {
                        model.remove(id: item.id)
                    }
                    parentDismiss()
                    DDLogVerbose("\(Date()): Произошло удаление задачи")
                }
                .foregroundStyle(Color.red)
                .font(.system(size: 20))
                .padding(10)
                Spacer()
            }
        }
    }
}
