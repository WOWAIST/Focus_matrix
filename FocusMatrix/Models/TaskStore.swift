import Foundation
import Combine

final class TaskStore: ObservableObject {
    @Published var tasks: [TaskItem] = []

    private let saveURL: URL
    private var timer: AnyCancellable?

    init() {
        let appSupport = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("FocusMatrix")
        try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        saveURL = appSupport.appendingPathComponent("tasks.json")
        load()
        startAutoUpgradeTimer()
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
        tasks[idx].isImportant        = quadrant.isImportant
        tasks[idx].isUrgent           = quadrant.isUrgent
        tasks[idx].autoUpgradedUrgency = false  // 수동 이동 시 자동 업그레이드 표시 해제
        tasks[idx].updatedAt          = Date()
        save()
    }

    func deleteCompleted(matching ids: [UUID]) {
        tasks.removeAll { ids.contains($0.id) }
        save()
    }

    // MARK: - Auto-upgrade urgency

    /// 마감까지 24시간 이내인 작업을 자동으로 urgent로 전환 (Q2→Q1, Q4→Q3)
    private func startAutoUpgradeTimer() {
        checkAndUpgradeUrgency()
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.checkAndUpgradeUrgency() }
    }

    private func checkAndUpgradeUrgency() {
        let now       = Date()
        let threshold = 24.0 * 60 * 60  // 24시간
        var changed   = false

        for i in tasks.indices {
            guard
                !tasks[i].isCompleted,
                !tasks[i].isUrgent,
                let due = tasks[i].dueDate,
                due.timeIntervalSince(now) <= threshold,
                due > now  // 이미 지난 마감은 제외
            else { continue }

            tasks[i].isUrgent            = true
            tasks[i].autoUpgradedUrgency = true
            tasks[i].updatedAt           = now
            changed = true
        }
        if changed { save() }
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
