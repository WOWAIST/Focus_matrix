import SwiftUI

struct MatrixView: View {
    @Binding var editingTask: TaskItem?
    let onTapEmpty: (Quadrant) -> Void

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    QuadrantView(quadrant: .doNow,    editingTask: $editingTask, onTapEmpty: onTapEmpty)
                    QuadrantView(quadrant: .schedule, editingTask: $editingTask, onTapEmpty: onTapEmpty)
                }
                HStack(spacing: 1) {
                    QuadrantView(quadrant: .delegate_, editingTask: $editingTask, onTapEmpty: onTapEmpty)
                    QuadrantView(quadrant: .eliminate, editingTask: $editingTask, onTapEmpty: onTapEmpty)
                }
            }
            .background(Color(NSColor.separatorColor))
        }
    }
}
