import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: BeerWeatherEntry

    private var amber: Color { Color(red: 0.91, green: 0.63, blue: 0.13) }
    private var grey: Color  { Color(red: 0.56, green: 0.60, blue: 0.67) }
    private var accent: Color { entry.isGood ? amber : grey }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Left — beer glass
            WidgetBeerGlassView(fillFraction: CGFloat(entry.score) / 100.0)
                .frame(width: 80, height: 110)
                .padding(.leading, 16)

            Spacer()

            // Right — info
            VStack(alignment: .trailing, spacing: 5) {
                Text(entry.locationName.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(grey)

                Text(entry.tierLabel)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(accent)

                HStack(spacing: 10) {
                    Label("\(Int(entry.temperature.rounded()))°", systemImage: "thermometer.medium")
                    Label("\(Int(entry.precipitationChance * 100))%", systemImage: "umbrella.fill")
                    Label("\(Int(entry.windSpeed.rounded()))m/s", systemImage: "wind")
                }
                .font(.system(size: 11))
                .foregroundStyle(grey)
                .labelStyle(.titleAndIcon)
            }
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
