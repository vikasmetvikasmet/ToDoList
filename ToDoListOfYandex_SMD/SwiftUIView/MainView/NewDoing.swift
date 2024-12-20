import SwiftUI
import CocoaLumberjackSwift

struct NewDoing: View {
    @Binding var showingPlusDo: Bool
    var body: some View {
        Button(
            action: {
                DDLogVerbose("\(Date()) Произведен успешный переход на второй экран с помощью поле НОВОЕ")
                showingPlusDo.toggle()
            }, label: {
                Text("Новое")
                    .foregroundStyle(.gray)
                    .padding(10)
            })
    }
}
