//
//   AddView.swift
//  ToDoListOfYandex_SMD
//
//  Created by Vika on 26.06.2024.
//
import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.presentationMode) var presentationMode1
    @ObservedObject var domany: manyDo
    @State private var text = ""
    @State private var type = "нет"
    @State private var priority: TodoItem.Priority = .normal
    @State private var deadline = Date()
    @State private var sharingToggle = false
    @State private var showCalander = false
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Section {
                        TextField("Что нужно сделать?", text: $text, axis: .vertical)
                            .padding(.bottom, 50)
                            .lineLimit(100)
                    }
                }
                Section {
                    HStack {
                        Text("Важность")
                        Spacer()
                        Picker("", selection: $priority) {
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
                    Toggle(isOn: $sharingToggle) {
                        VStack {
                            Text("Сделать до")
                            if sharingToggle == true {
                                Text(formatDate(deadline))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        withAnimation {
                                            showCalander.toggle()
                                        }
                                    }
                            }
                        }
                    }
                    .onChange(of: sharingToggle ) { newValue in
                        if newValue {
                            deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                        } else {
                            showCalander = false
                        }
                    }
                    if sharingToggle && showCalander {
                        DatePicker("Выберите дату", selection: $deadline, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Удалить") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundStyle(Color.red)
                        .font(.system(size: 20))
                        .padding(10)
                        Spacer()
                    }
                }
            }.navigationBarTitle("Дело века", displayMode: .inline)
                .navigationBarItems(trailing: Button("Сохранить") {
                    if self.text != "" {
                        let item = TodoItem(text: self.text, deadline: self.deadline, priority: self.priority)
                        self.domany.todoList.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
                .navigationBarItems(leading: Button("Отменить") {
                    self.presentationMode1.wrappedValue.dismiss()
                })
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM YYYY"
        return formatter.string(from: date)
    }
}
#Preview {
    AddView(domany: manyDo())
}
