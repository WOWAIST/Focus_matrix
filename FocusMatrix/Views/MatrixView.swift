import SwiftUI

struct MatrixView: View {
    @Binding var editingTask: TaskItem?

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    QuadrantView(quadrant: .doNow,    editingTask: $editingTask)
                    QuadrantView(quadrant: .schedule, editingTask: $editingTask)
                }
                HStack(spacing: 1) {
                    QuadrantView(quadrant: .delegate_, editingTask: $editingTask)
                    QuadrantView(quadrant: .eliminate, editingTask: $editingTask)
                }
            }
            .background(Color(NSColor.separatorColor))
        }
    }
}
