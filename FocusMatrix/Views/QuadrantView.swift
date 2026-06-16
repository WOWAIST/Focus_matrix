import SwiftUI

struct QuadrantView: View {
    let quadrant: Quadrant
    @Binding var editingTask: TaskItem?
    let onTapEmpty: (Quadrant) -> Void

    @EnvironmentObject var store: TaskStore
    @State private var isTargeted = false

    private var tasks: [TaskItem] { store.tasks(for: quadrant) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()
            taskList
        }
        .background(
            isTargeted
                ? quadrant.color.opacity(0.06)
                : Color(NSColor.controlBackgroundColor)
        )
        .animation(.easeInOut(duration: 0.15), value: isTargeted)
        .dropDestination(for: String.self) { items, _ in
            guard
                let idString = items.first,
                let uuid = UUID(uuidString: idString)
            else { return false }
            store.move(uuid, to: quadrant)
            return true
        } isTargeted: { targeted in
            isTargeted = targeted
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(quadrant.title)
                    .font(.headline)
                    .foregroundColor(quadrant.color)
                Text(quadrant.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if !tasks.isEmpty {
                Text("\(tasks.count)")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(quadrant.color)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(quadrant.color.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var taskList: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(tasks) { task in
                    TaskCardView(task: task) {
                        editingTask = task
                    }
                    .draggable(task.id.uuidString)
                }

                addButton
            }
            .padding(10)
        }
    }

    private var addButton: some View {
        Button {
            onTapEmpty(quadrant)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "plus")
                    .font(.system(size: 11, weight: .semibold))
                Text("작업 추가")
                    .font(.caption)
            }
            .foregroundColor(quadrant.color.opacity(0.7))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(quadrant.color.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(quadrant.color.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [4]))
            )
        }
        .buttonStyle(.plain)
    }
}
