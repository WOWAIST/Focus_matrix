import SwiftUI

struct TaskCardView: View {
    let task: TaskItem
    @EnvironmentObject var store: TaskStore
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            completeButton
            taskInfo
            Spacer(minLength: 0)
            autoUpgradeBadge
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: .black.opacity(isHovered ? 0.08 : 0.04), radius: isHovered ? 4 : 2, y: 1)
        )
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .onTapGesture(perform: onTap)
        .contextMenu {
            Button("Edit") { onTap() }
            Divider()
            Button("Delete") {
                store.delete(task.id)
            }
        }
    }

    // 자동으로 urgent 전환된 작업임을 표시하는 뱃지
    @ViewBuilder
    private var autoUpgradeBadge: some View {
        if task.autoUpgradedUrgency {
            HStack(spacing: 3) {
                Image(systemName: "bolt.fill")
                    .font(.caption2)
                Text("24h")
                    .font(.caption2)
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Color.orange.opacity(0.12))
            .clipShape(Capsule())
            .help("마감 24시간 이내로 자동으로 긴급 전환되었습니다")
        }
    }

    private var completeButton: some View {
        Button {
            withAnimation(.spring()) {
                store.setCompleted(task.id, true)
            }
        } label: {
            Image(systemName: isHovered ? "checkmark.circle" : "circle")
                .font(.system(size: 17))
                .foregroundColor(isHovered ? .green : Color(NSColor.tertiaryLabelColor))
                .animation(.easeInOut(duration: 0.12), value: isHovered)
        }
        .buttonStyle(.plain)
        .help("Mark as complete")
    }

    @ViewBuilder
    private var taskInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(task.title)
                .font(.callout)
                .lineLimit(2)

            if let note = task.note, !note.isEmpty {
                Text(note)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            if let due = task.dueDate {
                HStack(spacing: 4) {
                    Label(
                        due.formatted(date: .abbreviated, time: .shortened),
                        systemImage: "calendar"
                    )
                    .font(.caption2)
                    .foregroundColor(due < Date() ? .red : .secondary)

                    if task.notifyMinutesBefore != nil {
                        Image(systemName: "bell.fill")
                            .font(.caption2)
                            .foregroundColor(.blue.opacity(0.7))
                    }
                }
            }
        }
    }
}
