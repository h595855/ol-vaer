import SwiftUI

struct WeatherStatsRow: View {
    let snapshot: WeatherSnapshot
    @AppStorage("useFahrenheit") private var useFahrenheit = false

    private var tempString: String {
        if useFahrenheit {
            return "\(Int((snapshot.temperature * 9 / 5 + 32).rounded()))°F"
        }
        return "\(Int(snapshot.temperature.rounded()))°C"
    }

    var body: some View {
        HStack(spacing: Theme.spacingS) {
            StatPill(icon: "thermometer.medium", value: tempString)
            StatPill(icon: "umbrella.fill",      value: "\(Int(snapshot.precipitationChance * 100))%")
            StatPill(icon: "wind",               value: "\(Int(snapshot.windSpeed.rounded())) m/s")
        }
    }
}

private struct StatPill: View {
    let icon: String
    let value: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Theme.textSecondary)
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerS)
                .fill(Color.white.opacity(0.65))
        )
    }
}
