import SwiftUI

@main
struct FocusMatrixApp: App {
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup("Focus Matrix") {
            ContentView()
                .environmentObject(store)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Task") {
                    NotificationCenter.default.post(name: .showAddTask, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }

        MenuBarExtra {
            MenuBarContentView()
                .environmentObject(store)
        } label: {
            Image(systemName: "square.grid.2x2.fill")
        }
        .menuBarExtraStyle(.window)
    }
}

extension Notification.Name {
    static let showAddTask = Notification.Name("com.wowaist.focusmatrix.showAddTask")
}
