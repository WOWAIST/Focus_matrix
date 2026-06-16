import SwiftUI

let notifyOptions: [(label: String, minutes: Int?)] = [
    ("없음",    nil),
    ("5분 전",  5),
    ("10분 전", 10),
    ("15분 전", 15),
    ("30분 전", 30),
    ("1시간 전", 60),
    ("2시간 전", 120),
    ("1일 전",  1440),
]

struct DueDateSection: View {
    @Binding var hasDueDate: Bool
    @Binding var dueDate: Date
    @Binding var notifyMinutesBefore: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("마감 일시 설정", isOn: $hasDueDate.animation())

            if hasDueDate {
                DatePicker(
                    "",
                    selection: $dueDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()

                notificationPicker

                if let mins = notifyMinutesBefore {
                    notifyPreview(minutesBefore: mins)
                }
            }
        }
    }

    private var notificationPicker: some View {
        HStack(spacing: 8) {
            Image(systemName: "bell")
                .foregroundColor(.secondary)
                .font(.callout)

            Picker("알림", selection: $notifyMinutesBefore) {
                ForEach(notifyOptions, id: \.minutes) { option in
                    Text(option.label).tag(option.minutes)
                }
            }
            .frame(width: 120)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
        )
    }

    private func notifyPreview(minutesBefore: Int) -> some View {
        let notifyAt = dueDate.addingTimeInterval(TimeInterval(-minutesBefore * 60))
        return HStack(spacing: 4) {
            Image(systemName: "bell.fill")
                .font(.caption2)
                .foregroundColor(.blue)
            Text("\(notifyAt.formatted(date: .abbreviated, time: .shortened)) 에 알림")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

func defaultDueDate() -> Date {
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    components.hour   = 18
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
}
