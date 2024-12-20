import SwiftUI

struct CalendarView: View {
    @Binding var sharingToggle: Bool
    @Binding var showCalander: Bool
    @Binding var selectedDeadline: Date
    var body: some View {
        if sharingToggle && showCalander {
            DatePicker("Выберите дату", selection: $selectedDeadline, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}
