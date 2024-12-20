//
//  ContentView.swift
//  ToDoListOfYandex_SMD
//
//  Created by Vika on 19.06.2024.
//

import SwiftUI

class ManyDo: ObservableObject {
    @Published var todoList = [TodoItem]()
}
struct ContentView: View {
    @ObservedObject var doItem = FileCatche()
    @EnvironmentObject var viewModel: FileCatche
    @ObservedObject var domany = ManyDo()
    @State private var showingPlusDo = false
    //
    var body: some View {
        NavigationStack {
            List {
                ForEach(domany.todoList, id: \.id) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(item.text)")
                                .lineLimit(3)
                        }
                        HStack {
                            if let deadlineDate = item.deadline {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text(formatDate(deadlineDate))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            if let index = domany.todoList.firstIndex(where: { $0.id == item.id }) {
                                domany.todoList.remove(at: index)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }.tint(.red)
                        Button {
                            //
                        }label: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
            }.navigationBarTitle("Мои дела \u{1F9B9}")
                .overlay(alignment: .bottom) {
                    addPlus
                }
                .sheet(isPresented: $showingPlusDo) {
                    AddView(domany: self.domany)
                }
        }
    }
    var addPlus: some View {
        Button(
            action: {
                showingPlusDo.toggle()
            },
            label: {
                Image(systemName: "plus")
                    .fontWeight(.bold)
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color(UIColor.systemBlue)
                        .shadow(
                            .drop(
                                color: .black.opacity(0.25), radius: 7, x: 0, y: 10)),
                                in: .circle)
                    .frame(width: 44, height: 44)
            }
        )
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
