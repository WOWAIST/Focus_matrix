import SwiftUI

struct QuadrantToggle: View {
    let label: String
    @Binding var isOn: Bool
    let color: Color

    var body: some View {
        Button { isOn.toggle() } label: {
            HStack(spacing: 6) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isOn ? color : .secondary)
                    .animation(.easeInOut(duration: 0.12), value: isOn)
                Text(label)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(isOn ? color.opacity(0.1) : Color(NSColor.controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isOn ? color.opacity(0.4) : Color(NSColor.separatorColor), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.12), value: isOn)
        }
        .buttonStyle(.plain)
    }
}
