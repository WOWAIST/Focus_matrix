import SwiftUI

struct QuadrantView: View {
    let quadrant: Quadrant
    @Binding var editingTask: TaskItem?
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

                if tasks.isEmpty {
                    emptyState
                }
            }
            .padding(10)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 6) {
            Image(systemName: "tray")
                .font(.system(size: 24))
                .foregroundColor(quadrant.color.opacity(0.35))
            Text("Drop tasks here")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}
