import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var store: TaskStore
    var task: TaskItem?
    var presetQuadrant: Quadrant?
    let onSave: () -> Void

    @State private var title               = ""
    @State private var note                = ""
    @State private var isImportant         = false
    @State private var isUrgent            = false
    @State private var hasDueDate          = false
    @State private var dueDate             = defaultDueDate()
    @State private var notifyMinutesBefore: Int? = nil

    private var isEditing: Bool { task != nil }

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
                ClassifySection(isImportant: $isImportant, isUrgent: $isUrgent)
            }

            fieldSection("마감 일시") {
                DueDateSection(
                    hasDueDate:          $hasDueDate,
                    dueDate:             $dueDate,
                    notifyMinutesBefore: $notifyMinutesBefore
                )
            }

            Spacer()

            HStack {
                Button("Cancel") { onSave() }
                    .keyboardShortcut(.escape, modifiers: [])
                Spacer()
                Button(isEditing ? "Save Changes" : "Add Task") { save() }
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
        if let quadrant = presetQuadrant, task == nil {
            isImportant = quadrant.isImportant
            isUrgent    = quadrant.isUrgent
        }
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

        let finalDueDate = hasDueDate ? dueDate : nil
        let finalNotify  = hasDueDate ? notifyMinutesBefore : nil

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
