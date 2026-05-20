import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: BeerWeatherEntry

    private var accent: Color { entry.isGood ? Color(red: 0.91, green: 0.63, blue: 0.13) : Color(red: 0.56, green: 0.60, blue: 0.67) }
    private var grey: Color { Color(red: 0.56, green: 0.60, blue: 0.67) }

    var body: some View {
        VStack(spacing: 6) {
            WidgetBeerGlassView(fillFraction: CGFloat(entry.score) / 100.0)
                .frame(width: 60, height: 80)

            Text(entry.tierLabel)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(accent)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(entry.locationName)
                .font(.system(size: 10))
                .foregroundStyle(grey)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 12)
    }
}
