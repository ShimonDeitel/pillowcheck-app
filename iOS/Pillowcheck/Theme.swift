import SwiftUI

/// Bespoke palette + type for Pillowcheck - Pillow Replacement Reminder.
enum Theme {
    static let background = Color(hex: "#111713")
    static let primary = Color(hex: "#3D5A50")
    static let secondary = Color(hex: "#7A9A8B")
    static let accent = Color(hex: "#DDA15E")
    static let cardBackground = Color(hex: "#111713").opacity(0.6)

    static let titleFont = Font.custom("Optima", size: 28).weight(.bold)
    static let headlineFont = Font.custom("Optima", size: 18).weight(.semibold)
    static let bodyFont = Font.custom("Optima", size: 16)
    static let captionFont = Font.custom("Optima", size: 13)
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
