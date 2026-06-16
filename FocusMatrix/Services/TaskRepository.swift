import Foundation

struct TaskRepository {
    private let saveURL: URL

    init() {
        let appSupport = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("FocusMatrix")
        try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        saveURL = appSupport.appendingPathComponent("tasks.json")
    }

    func save(_ tasks: [TaskItem]) {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        try? data.write(to: saveURL, options: .atomic)
    }

    func load() -> [TaskItem] {
        guard
            let data    = try? Data(contentsOf: saveURL),
            let decoded = try? JSONDecoder().decode([TaskItem].self, from: data)
        else { return [] }
        return decoded
    }
}
