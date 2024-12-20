import SwiftUI
import CocoaLumberjackSwift

struct Title: View {
    @StateObject var model: TodoItemModel
    @Binding var showIsDone: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            
            Text("Выполнено — \(model.todoItems.filter { $0.isDone }.count)")
                .padding(.leading)
                .foregroundColor(.gray)
                .font(.system(size: 17))
            Spacer()
            Menu {
                Button(action: {
                    DDLogVerbose("\(Date()): Нажат переключатель Скрыть/Показать")
                    showIsDone.toggle()
                }) {
                    Text(showIsDone ? "Скрыть" : "Показать")
                }
                Button(action: {
                    DDLogVerbose("\(Date()): Включена сортировка по выполнению")
                    model.sortFilters(by: .done)
                }) {
                    Text("По выполнению")
                }
                
                Button(action: {
                    DDLogVerbose("\(Date()): Включена сортировка по дате создания")
                    model.sortFilters(by: .createdAt)
                }) {
                    Text("По добавлению")
                }
                
                Button(action: {
                    DDLogVerbose("\(Date()): Включена сортировка по важности")
                    model.sortFilters(by: .priority)
                }) {
                    Text("По важности")
                }
                
                Button(action: {
                    DDLogVerbose("\(Date()): Включена сортировка по сроку выполнения")
                    model.sortFilters(by: .deadline)
                }) {
                    Text("По сроку выполнения")
                }
            } label: {
                Text("Меню")
                    .padding(.trailing)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
            }
        }
    }
}
