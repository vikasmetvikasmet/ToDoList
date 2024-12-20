import SwiftUI

struct GoAddView: View {
    @Binding var remakeTodo: Bool
    @StateObject var model: TodoItemModel
    var currentItem: TodoItem?
    var body: some View {
        Button {
            remakeTodo = true
        }label: {
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }.sheet(isPresented: $remakeTodo) {
            AddView(
                model: model,
                currentItem: currentItem)
        }
    }
}
