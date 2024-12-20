import SwiftUI
import CocoaLumberjackSwift

struct CancelButton: View {
    var parentDismissCancel: DismissAction
    var body: some View {
        Button("Отменить") {
            parentDismissCancel()
            DDLogVerbose("\(Date()): Произошла отмены задачи")
        }
    }
}
