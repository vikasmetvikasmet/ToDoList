import SwiftUI

struct InputDoing: View {
    @Binding var selectedText: String
    @Binding var showColor: Bool
    @Binding var selectedColor: Color
    @FocusState private var isActive: Bool
    
    var body: some View {
        Section {
            ZStack(alignment: .topTrailing) {
                TextField("Что нужно сделать?", text: $selectedText, axis: .vertical)
                    .keyboardType(.default)
                    .padding( .bottom, 50)
                    .lineLimit(100)
                    .focused($isActive)
                Spacer()
                if showColor {
                    Rectangle()
                        .fill(selectedColor)
                        .offset(x: 10)
                        .frame(width: 5)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
                isActive = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    
}
