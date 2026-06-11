import SwiftUI

enum CompletedFilter: String, CaseIterable {
    case today = "Today"
    case week  = "This Week"
    case all   = "All"
}

struct CompletedView: View {
    @EnvironmentObject var store: TaskStore
    @State private var filter: CompletedFilter = .all

    private var filteredTasks: [TaskItem] {
        let calendar = Calendar.current
        let now = Date()
        return store.completedTasks.filter { task in
            switch filter {
            case .today:
                return calendar.isDateInToday(task.updatedAt)
            case .week:
                let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now)!
                return task.updatedAt >= weekAgo
            case .all:
                return true
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()
            content
        }
    }

    private var toolbar: some View {
        HStack {
            Text("Completed")
                .font(.headline)
            Text("·")
                .foregroundColor(.secondary)
            Text("\(filteredTasks.count) tasks")
                .font(.callout)
                .foregroundColor(.secondary)

            Spacer()

            Picker("Filter", selection: $filter) {
                ForEach(CompletedFilter.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)

            if !filteredTasks.isEmpty {
                Button("Clear All") {
                    store.deleteCompleted(matching: filteredTasks.map(\.id))
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.bar)
    }

    @ViewBuilder
    private var content: some View {
        if filteredTasks.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 44))
                    .foregroundColor(.secondary)
                Text("No completed tasks")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(filteredTasks) { task in
                    CompletedTaskRow(task: task)
                }
                .onDelete { indexSet in
                    let ids = indexSet.map { filteredTasks[$0].id }
                    store.deleteCompleted(matching: ids)
                }
            }
            .listStyle(.inset)
        }
    }
}

struct CompletedTaskRow: View {
    let task: TaskItem
    @EnvironmentObject var store: TaskStore

    var body: some View {
        HStack(spacing: 10) {
            Button {
                withAnimation {
                    store.setCompleted(task.id, false)
                }
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 17))
                    .foregroundColor(.green)
            }
            .buttonStyle(.plain)
            .help("Mark as incomplete")

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .strikethrough(color: .secondary)
                    .foregroundColor(.secondary)
                Text(Quadrant(isImportant: task.isImportant, isUrgent: task.isUrgent).title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(task.updatedAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive) {
                store.delete(task.id)
            }
        }
    }
}
