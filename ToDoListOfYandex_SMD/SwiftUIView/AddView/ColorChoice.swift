import SwiftUI

struct ColorChoice: View {
    @Binding var selectedColor: Color
    @Binding var showColor: Bool
    var currentColorHex: String {
        selectedColor.hexComponentsString()
    }
    var body: some View {
        VStack {
            HStack {
                Text("Цвет")
                Spacer()
                Toggle("", isOn: $showColor)
            }
            .foregroundStyle(Color(UIColor.label))
            .frame(height: 20)
            
            if showColor {
                ColorPicker(selectedColor.hexComponentsString(), selection: $selectedColor, supportsOpacity: false)
            }
        }
    }
}
