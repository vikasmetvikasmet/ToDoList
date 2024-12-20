import SwiftUI
import CocoaLumberjackSwift

struct ButtonPlus: View {
    @Binding var showingPlusDo: Bool
    var body: some View {
        Button {
            DDLogVerbose("\(Date()) Произведен успешный переход на второй экран с помощью кнопки +")
            showingPlusDo = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}
