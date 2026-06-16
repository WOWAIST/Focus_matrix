import SwiftUI

extension Quadrant {
    var color: Color {
        switch self {
        case .doNow:     return Color(red: 0.86, green: 0.22, blue: 0.18)
        case .schedule:  return Color(red: 0.20, green: 0.48, blue: 0.93)
        case .delegate_: return Color(red: 0.93, green: 0.52, blue: 0.18)
        case .eliminate: return Color(red: 0.56, green: 0.56, blue: 0.58)
        }
    }
}
