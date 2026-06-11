import Foundation
import Combine

final class TaskStore: ObservableObject {
    @Published var tasks: [TaskItem] = []

    private let saveURL: URL

    init() {
        let appSupport = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("FocusMatrix")
        try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        saveURL = appSupport.appendingPathComponent("tasks.json")
        load()
    }

    // MARK: - Derived collections

    var activeTasks: [TaskItem] {
        tasks.filter { !$0.isCompleted }
    }

    var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }.sorted { $0.updatedAt > $1.updatedAt }
    }

    func tasks(for quadrant: Quadrant) -> [TaskItem] {
        activeTasks
            .filter { $0.isImportant == quadrant.isImportant && $0.isUrgent == quadrant.isUrgent }
            .sorted { $0.createdAt > $1.createdAt }
    }

    // MARK: - Mutations

    func add(_ task: TaskItem) {
        tasks.append(task)
        save()
    }

    func update(_ updated: TaskItem) {
        guard let idx = tasks.firstIndex(where: { $0.id == updated.id }) else { return }
        tasks[idx] = updated
        save()
    }

    func delete(_ id: UUID) {
        tasks.removeAll { $0.id == id }
        save()
    }

    func setCompleted(_ id: UUID, _ completed: Bool) {
        guard let idx = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[idx].isCompleted = completed
        tasks[idx].updatedAt   = Date()
        save()
    }

    func move(_ id: UUID, to quadrant: Quadrant) {
        guard let idx = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[idx].isImportant = quadrant.isImportant
        tasks[idx].isUrgent    = quadrant.isUrgent
        tasks[idx].updatedAt   = Date()
        save()
    }

    func deleteCompleted(matching ids: [UUID]) {
        tasks.removeAll { ids.contains($0.id) }
        save()
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        try? data.write(to: saveURL, options: .atomic)
    }

    private func load() {
        guard
            let data    = try? Data(contentsOf: saveURL),
            let decoded = try? JSONDecoder().decode([TaskItem].self, from: data)
        else { return }
        tasks = decoded
    }
}
