import SwiftUI
import FormatDateFramework

struct DoView: View {
    var item: TodoItem
    var body: some View {
        
        VStack(alignment: .leading, spacing: 3) {
            HStack{
                ShowPriority(item: item)
                ShowText(item: item)
            }
            ShowDeadline(item: item)
        }
        Spacer()
        ShowColor(item: item)
    }
}
struct ShowDeadline: View {
    var item: TodoItem
    var body: some View {
        HStack {
            if let deadlineDate = item.deadline {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
                if calendar.startOfDay(for: deadlineDate) != tomorrow {
                    Image(systemName: "calendar")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 16, height: 16)
                    Text(formatDateShort(deadlineDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
struct ShowPriority: View {
    var item: TodoItem
    var body: some View {
        HStack {
            if item.priority.rawValue == "low" {
                Text("\u{2193}")
                    .foregroundStyle(.gray)
            }else if item.priority.rawValue == "important"{
                Text("\u{203C}")
            }else {
                Text("")
                    .padding(.trailing, 10)
            }
        }
    }
}

struct ShowText: View {
    @Environment(\.colorScheme) var colorScheme
    var item: TodoItem
    var body: some View {
        
        Text(item.text)
            .lineLimit(3)
            .strikethrough(item.isDone ? true : false)
            .foregroundColor(item.isDone ? .gray : (colorScheme == .dark ? .white : .black))
    }
}

struct ShowColor: View {
    var item: TodoItem
    var body: some View {
        if (item.color != ""){
            Color(hex: item.color)
                .frame(width: 15, height: 15)
                .clipShape(Circle())
        }
        Color(item.color)
            .frame(width: 15, height: 15)
            .clipShape(Circle())
    }
}
