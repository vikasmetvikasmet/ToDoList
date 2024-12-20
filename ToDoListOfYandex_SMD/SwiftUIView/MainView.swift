import SwiftUI
import CocoaLumberjackSwift
import FormatDateFramework

struct MainView: View {
    @StateObject var model: TodoItemModel = TodoItemModel()
    @State private var showingPlusDo = false
    @State private var showIsDone: Bool = false
    @State private var remakeTodo = false
    @State var currentItem: TodoItem?
    @State private var areDoneTasksShown = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationStack {
            Title(model: model, showIsDone: $showIsDone)
            List {
                Section {
                    ForEach(model.todoItems, id: \.id) { item in
                        if showIsDone || (!showIsDone && !item.isDone) {
                            HStack {
                                CircleDoing(item: item, model: model)
                                DoView(item: item)
                                GoAddView(remakeTodo: $remakeTodo, model: model, currentItem: item)
                            }
                            .swipeActions(edge: .leading) {
                                CheckmarkDoing(model: model, item: item)
                            }
                            .swipeActions(edge: .trailing) {
                                TrashDoing(model: model, item: item)
                            }
                        }
                    }
                    NewDoing(showingPlusDo: $showingPlusDo)
                }
            }
            .navigationBarTitle("Мои дела \u{1F9B9}")
            .overlay(alignment: .bottom) {
                ButtonPlus(showingPlusDo: $showingPlusDo)
            }
            .sheet(isPresented: $showingPlusDo) {
                AddView(model: self.model, currentItem: currentItem)
            }
            .toolbar{
                ToolbarItem(placement: .primaryAction) {
                    if model.isLoading{
                        ProgressView()
                    }else {
                        ProgressView().hidden()
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
