import SwiftUI

enum AppTab: String, CaseIterable {
    case matrix, completed

    var label: String {
        switch self {
        case .matrix:    return "Matrix"
        case .completed: return "Completed"
        }
    }

    var icon: String {
        switch self {
        case .matrix:    return "square.grid.2x2"
        case .completed: return "checkmark.circle"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var store: TaskStore
    @State private var selectedTab: AppTab = .matrix
    @State private var showAddTask = false
    @State private var editingTask: TaskItem?

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()

            switch selectedTab {
            case .matrix:
                MatrixView(editingTask: $editingTask)
            case .completed:
                CompletedView()
            }
        }
        .frame(minWidth: 900, minHeight: 620)
        .sheet(isPresented: $showAddTask) {
            AddTaskView(task: nil) { showAddTask = false }
                .environmentObject(store)
        }
        .sheet(item: $editingTask) { task in
            AddTaskView(task: task) { editingTask = nil }
                .environmentObject(store)
        }
        .onReceive(NotificationCenter.default.publisher(for: .showAddTask)) { _ in
            showAddTask = true
        }
    }

    private var toolbar: some View {
        HStack(spacing: 12) {
            Picker("", selection: $selectedTab) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Label(tab.label, systemImage: tab.icon).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)

            Spacer()

            Button {
                showAddTask = true
            } label: {
                Label("New Task", systemImage: "plus")
            }
            .help("New Task (⌘N)")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.bar)
    }
}
