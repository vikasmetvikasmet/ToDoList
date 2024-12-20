import SwiftUI
import CocoaLumberjackSwift

struct SaveButton: View {
    @Binding var selectedText: String
    @Binding var showColor: Bool
    @StateObject var model: TodoItemModel
    @Binding var selectedPriority: TodoItem.Priority
    @Binding var selectedDeadline: Date
    @Binding var selectedColor: Color
    @Environment(\.presentationMode) var presentationMode
    var parentDismissSave: DismissAction
    var currentItem: TodoItem?
    var currentColorHex: String {
        selectedColor.hexComponentsString()
    }
    var body: some View {
        
        Button("Сохранить") {
            if self.selectedText != "" && currentItem == nil {
                let item = TodoItem(text: self.selectedText, deadline: self.selectedDeadline, priority: self.selectedPriority, color: showColor ? self.currentColorHex : "")
                self.model.add(item)
                DDLogVerbose("\(Date()): Произошло сохранение задачи")
                parentDismissSave()
            }
            else if let currentItem = currentItem {
                model.updateToDoItem(
                    id: currentItem.id, newText: selectedText,
                    newPriority: selectedPriority,
                    newDeadline: selectedDeadline,
                    newIsDone: currentItem.isDone,
                    newColor:showColor ? currentColorHex : "")
                DDLogVerbose("\(Date()): Произошло изменение задачи")
                parentDismissSave()
            }
        }
    }
}

