import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject var store: TaskStore
    @State private var showAddTask = false

    private var q1Tasks: [TaskItem] { store.tasks(for: .doNow) }
    private var q2Tasks: [TaskItem] { store.tasks(for: .schedule) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if !q1Tasks.isEmpty {
                        menuSection(title: "Do Now", tasks: q1Tasks, color: Quadrant.doNow.color)
                        Divider().padding(.horizontal, 12)
                    }
                    if !q2Tasks.isEmpty {
                        menuSection(title: "Schedule", tasks: q2Tasks, color: Quadrant.schedule.color)
                    }
                    if q1Tasks.isEmpty && q2Tasks.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.seal")
                                .font(.system(size: 28))
                                .foregroundColor(.secondary)
                            Text("Focus time — no urgent tasks")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    }
                }
            }
            .frame(maxHeight: 320)

            Divider()
            footer
        }
        .frame(width: 290)
        .sheet(isPresented: $showAddTask) {
            AddTaskView(task: nil) { showAddTask = false }
                .environmentObject(store)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Focus Matrix")
                    .font(.headline)
                Text("\(store.activeTasks.count) active tasks")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                showAddTask = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .help("Add new task")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var footer: some View {
        HStack {
            Button("Open App") {
                NSApp.activate(ignoringOtherApps: true)
            }
            .buttonStyle(.plain)
            .font(.callout)
            Spacer()
            Button("Quit") {
                NSApp.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.callout)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private func menuSection(title: String, tasks: [TaskItem], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .padding(.bottom, 6)

            ForEach(tasks.prefix(5)) { task in
                HStack(spacing: 8) {
                    Circle()
                        .fill(color)
                        .frame(width: 5, height: 5)
                    Text(task.title)
                        .font(.callout)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 5)
            }

            if tasks.count > 5 {
                Text("+\(tasks.count - 5) more")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 4)
            }
        }
        .padding(.bottom, 6)
    }
}
