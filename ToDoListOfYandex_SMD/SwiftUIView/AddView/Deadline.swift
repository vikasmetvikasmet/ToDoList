import SwiftUI
import FormatDateFramework

struct Deadline: View {
    @Binding var sharingToggle: Bool
    @Binding var selectedDeadline: Date
    @Binding var showCalander: Bool
    
    var body: some View {
        Toggle(isOn: $sharingToggle) {
            VStack(alignment: .leading) {
                Text("Сделать до")
                if sharingToggle == true {
                    Text(formatDateLong(selectedDeadline))
                        .font( .caption)
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
    }
}
