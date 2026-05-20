import SwiftUI

enum Theme {
    // MARK: - Colors
    static let beerAmber    = Color(red: 0.91, green: 0.63, blue: 0.13)
    static let beerLiquid   = Color(red: 0.82, green: 0.52, blue: 0.08)

    static let warmBg       = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let coldBg       = Color(red: 0.93, green: 0.95, blue: 0.96)

    static let textPrimary  = Color(red: 0.10, green: 0.10, blue: 0.18)
    static let textSecondary = Color(red: 0.56, green: 0.60, blue: 0.67)

    // MARK: - Spacing
    static let spacingXS: CGFloat  = 4
    static let spacingS: CGFloat   = 8
    static let spacingM: CGFloat   = 16
    static let spacingL: CGFloat   = 24
    static let spacingXL: CGFloat  = 40
    static let spacingXXL: CGFloat = 64

    // MARK: - Corner radii
    static let cornerS: CGFloat = 8
    static let cornerM: CGFloat = 16
    static let cornerL: CGFloat = 24

    // MARK: - Animations
    static let spring = Animation.spring(response: 0.6, dampingFraction: 0.78)
    static let ease   = Animation.easeInOut(duration: 0.35)
}
