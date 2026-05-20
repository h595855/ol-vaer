import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    let entry: BeerWeatherEntry

    private var amber: Color { Color(red: 0.91, green: 0.63, blue: 0.13) }
    private var grey: Color  { Color(red: 0.56, green: 0.60, blue: 0.67) }
    private var accent: Color { entry.isGood ? amber : grey }

    var body: some View {
        VStack(spacing: 0) {
            // Location
            Text(entry.locationName.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.6)
                .foregroundStyle(grey)
                .padding(.top, 22)

            Spacer()

            // Hero glass
            WidgetBeerGlassView(fillFraction: CGFloat(entry.score) / 100.0)
                .frame(width: 130, height: 190)

            Spacer()

            // Status
            Text(entry.tierLabel)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(accent)

            Text(sublabel)
                .font(.system(size: 13))
                .foregroundStyle(grey)
                .padding(.top, 3)

            Spacer()

            // Stats bar
            HStack(spacing: 28) {
                statView(icon: "thermometer.medium", value: "\(Int(entry.temperature.rounded()))°")
                statView(icon: "umbrella.fill",      value: "\(Int(entry.precipitationChance * 100))%")
                statView(icon: "wind",               value: "\(Int(entry.windSpeed.rounded())) m/s")
            }
            .padding(.bottom, 22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var sublabel: String {
        switch entry.score {
        case 81...100: return "Perfekt for en is kald øl ute"
        case 61...80:  return "Hyggelig å sitte ute"
        case 31...60:  return "Kanskje litt friskt"
        default:       return "Bedre med en inne-øl i dag"
        }
    }

    private func statView(icon: String, value: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(grey)
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(grey)
        }
    }
}
