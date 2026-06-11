import SwiftUI

// 알림 옵션: nil = 알림 없음
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

struct AddTaskView: View {
    @EnvironmentObject var store: TaskStore
    var task: TaskItem?
    let onSave: () -> Void

    @State private var title               = ""
    @State private var note                = ""
    @State private var isImportant         = false
    @State private var isUrgent            = false
    @State private var hasDueDate          = false
    @State private var dueDate             = defaultDueDate()
    @State private var notifyMinutesBefore: Int? = nil

    private var isEditing: Bool { task != nil }

    private var currentQuadrant: Quadrant {
        Quadrant(isImportant: isImportant, isUrgent: isUrgent)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(isEditing ? "Edit Task" : "New Task")
                .font(.title2)
                .fontWeight(.semibold)

            fieldSection("Title") {
                TextField("What needs to be done?", text: $title)
                    .textFieldStyle(.roundedBorder)
            }

            fieldSection("Note (optional)") {
                TextField("Add a note...", text: $note, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...5)
            }

            fieldSection("Classify") {
                HStack(spacing: 10) {
                    QuadrantToggle(label: "Important", isOn: $isImportant, color: .blue)
                    QuadrantToggle(label: "Urgent",    isOn: $isUrgent,    color: .red)
                }

                HStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(currentQuadrant.color)
                    Text(currentQuadrant.title)
                        .font(.callout)
                        .foregroundColor(currentQuadrant.color)
                    Text("·")
                        .foregroundColor(.secondary)
                    Text(currentQuadrant.subtitle)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(currentQuadrant.color.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .animation(.easeInOut(duration: 0.15), value: currentQuadrant.title)
            }

            fieldSection("마감 일시") {
                Toggle("마감 일시 설정", isOn: $hasDueDate.animation())

                if hasDueDate {
                    VStack(alignment: .leading, spacing: 10) {
                        // 날짜 + 시간 동시 선택
                        DatePicker(
                            "",
                            selection: $dueDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()

                        // 알림 설정
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

                        if let mins = notifyMinutesBefore {
                            let notifyAt = dueDate.addingTimeInterval(TimeInterval(-mins * 60))
                            HStack(spacing: 4) {
                                Image(systemName: "bell.fill")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                Text("\(notifyAt.formatted(date: .abbreviated, time: .shortened)) 에 알림")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }

            Spacer()

            HStack {
                Button("Cancel") { onSave() }
                    .keyboardShortcut(.escape, modifiers: [])
                Spacer()
                Button(isEditing ? "Save Changes" : "Add Task") {
                    save()
                }
                .keyboardShortcut(.return, modifiers: .command)
                .buttonStyle(.borderedProminent)
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(24)
        .frame(width: 460)
        .onAppear(perform: populateIfEditing)
    }

    @ViewBuilder
    private func fieldSection<Content: View>(
        _ label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            content()
        }
    }

    private func populateIfEditing() {
        guard let task else { return }
        title               = task.title
        note                = task.note ?? ""
        isImportant         = task.isImportant
        isUrgent            = task.isUrgent
        notifyMinutesBefore = task.notifyMinutesBefore
        if let due = task.dueDate {
            hasDueDate = true
            dueDate    = due
        }
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let finalDueDate   = hasDueDate ? dueDate : nil
        let finalNotify    = hasDueDate ? notifyMinutesBefore : nil

        if var existing = task {
            existing.title               = trimmed
            existing.note                = note.isEmpty ? nil : note
            existing.isImportant         = isImportant
            existing.isUrgent            = isUrgent
            existing.dueDate             = finalDueDate
            existing.notifyMinutesBefore = finalNotify
            existing.updatedAt           = Date()
            store.update(existing)
        } else {
            store.add(TaskItem(
                title:               trimmed,
                note:                note.isEmpty ? nil : note,
                isImportant:         isImportant,
                isUrgent:            isUrgent,
                dueDate:             finalDueDate,
                notifyMinutesBefore: finalNotify
            ))
        }
        onSave()
    }
}

// 기본 마감 시각: 오늘 오후 6시
private func defaultDueDate() -> Date {
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    components.hour   = 18
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
}

struct QuadrantToggle: View {
    let label: String
    @Binding var isOn: Bool
    let color: Color

    var body: some View {
        Button { isOn.toggle() } label: {
            HStack(spacing: 6) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isOn ? color : .secondary)
                    .animation(.easeInOut(duration: 0.12), value: isOn)
                Text(label)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(isOn ? color.opacity(0.1) : Color(NSColor.controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isOn ? color.opacity(0.4) : Color(NSColor.separatorColor), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.12), value: isOn)
        }
        .buttonStyle(.plain)
    }
}
