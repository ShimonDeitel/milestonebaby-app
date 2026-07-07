import SwiftUI

/// Bespoke palette for Milestone. Not shared with other apps in the portfolio.
enum Theme {
    static let background = Color(red: 0.106, green: 0.075, blue: 0.082)
    static let surface = Color(red: 0.153, green: 0.110, blue: 0.122)
    static let accent = Color(red: 0.910, green: 0.627, blue: 0.627)
    static let textPrimary = Color(red: 0.969, green: 0.922, blue: 0.914)
    static let textMuted = Color(red: 0.780, green: 0.608, blue: 0.608)

    static let titleFont: Font = .system(.title2, design: .rounded).weight(.bold)
    static let headlineFont: Font = .system(.headline, design: .rounded)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
