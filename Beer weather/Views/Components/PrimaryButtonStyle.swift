import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerM)
                    .fill(Theme.beerAmber)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
