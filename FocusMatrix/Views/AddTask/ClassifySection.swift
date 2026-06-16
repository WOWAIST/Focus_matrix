import SwiftUI

struct ClassifySection: View {
    @Binding var isImportant: Bool
    @Binding var isUrgent: Bool

    private var quadrant: Quadrant {
        Quadrant(isImportant: isImportant, isUrgent: isUrgent)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                QuadrantToggle(label: "Important", isOn: $isImportant, color: .blue)
                QuadrantToggle(label: "Urgent",    isOn: $isUrgent,    color: .red)
            }

            HStack(spacing: 8) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(quadrant.color)
                Text(quadrant.title)
                    .font(.callout)
                    .foregroundColor(quadrant.color)
                Text("·")
                    .foregroundColor(.secondary)
                Text(quadrant.subtitle)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(quadrant.color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .animation(.easeInOut(duration: 0.15), value: quadrant.title)
        }
    }
}
