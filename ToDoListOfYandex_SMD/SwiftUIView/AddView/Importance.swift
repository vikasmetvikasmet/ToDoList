import SwiftUI

struct Importance: View {
    @Binding var selectedPriority: TodoItem.Priority
    var body: some View {
        HStack {
            Text("Важность")
            
            Spacer()
            Picker("", selection: $selectedPriority) {
                Text("\u{2193}")
                    .tag(TodoItem.Priority.low)
                Text("нет")
                    .tag(TodoItem.Priority.normal)
                Text("\u{203C}")
                    .tag(TodoItem.Priority.high)
            }
            .pickerStyle(.segmented)
            .scaledToFit()
        }
    }
}
