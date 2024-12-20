import SwiftUI
import CocoaLumberjackSwift
import FormatDateFramework

struct AddView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @StateObject var model: TodoItemModel
    @State private var selectedText =  ""
    @State private var type = "нет"
    @State private var selectedPriority: TodoItem.Priority = .normal
    @State private var selectedDeadline = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var sharingToggle = false
    @State private var showCalander = false
    @State private var selectedColor: Color = .clear
    @State private var showColor = false
    var currentItem: TodoItem?
    var currentColorHex: String {
        selectedColor.hexComponentsString()
    }
    
    var body: some View {
        NavigationView {
            Form {
                InputDoing(selectedText: $selectedText, showColor: $showColor, selectedColor: $selectedColor)
                
                Section {
                    Importance(selectedPriority: $selectedPriority)
                    Deadline(sharingToggle: $sharingToggle, selectedDeadline: $selectedDeadline, showCalander: $showCalander)
                    CalendarView(sharingToggle: $sharingToggle, showCalander: $showCalander, selectedDeadline: $selectedDeadline)
                }
                ColorChoice(selectedColor: $selectedColor, showColor: $showColor)
                ButtonDelete(model: model, selectedItem: currentItem, parentDismiss: dismiss)
            }
            .navigationBarTitle("Дело века", displayMode: .inline)
            .navigationBarItems(trailing:
                                    SaveButton(selectedText: $selectedText, showColor: $showColor, model: model, selectedPriority: $selectedPriority, selectedDeadline: $selectedDeadline, selectedColor: $selectedColor, parentDismissSave: dismiss, currentItem: currentItem)
            )
            .navigationBarItems(leading:
                                    CancelButton(parentDismissCancel: dismiss)
            )
        }.onAppear {
            if let item = currentItem {
                selectedText = item.text
                selectedPriority = item.priority
                selectedDeadline = item.deadline ?? Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                if item.color != "" {
                    showColor = true
                    selectedColor = Color(item.color)
                    
                }
            }
        }
    }
}
