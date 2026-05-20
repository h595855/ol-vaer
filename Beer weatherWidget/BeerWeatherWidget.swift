import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct BeerWeatherEntry: TimelineEntry {
    let date: Date
    let score: Int
    let locationName: String
    let temperature: Double
    let precipitationChance: Double
    let windSpeed: Double
    let condition: String

    var isGood: Bool { score > 60 }
    var tierLabel: String {
        switch score {
        case 81...100: return "Øl-tid!"
        case 61...80:  return "Godt vær"
        case 31...60:  return "Ta med jakke"
        default:       return "Bli inne"
        }
    }

    static let placeholder = BeerWeatherEntry(
        date: .now, score: 85, locationName: "Bergen",
        temperature: 19, precipitationChance: 0.04, windSpeed: 2, condition: "sunny"
    )
    static let empty = BeerWeatherEntry(
        date: .now, score: 0, locationName: "—",
        temperature: 0, precipitationChance: 0, windSpeed: 0, condition: "cloudy"
    )
}

// MARK: - Provider

struct BeerWeatherProvider: TimelineProvider {
    func placeholder(in context: Context) -> BeerWeatherEntry { .placeholder }

    func getSnapshot(in context: Context, completion: @escaping (BeerWeatherEntry) -> Void) {
        completion(entry(from: SharedDataService.load()) ?? .placeholder)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BeerWeatherEntry>) -> Void) {
        let e = entry(from: SharedDataService.load()) ?? .empty
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: .now)!
        completion(Timeline(entries: [e], policy: .after(next)))
    }

    private func entry(from data: SharedWeatherData?) -> BeerWeatherEntry? {
        guard let d = data else { return nil }
        return BeerWeatherEntry(
            date: d.updatedAt,
            score: d.score,
            locationName: d.locationName,
            temperature: d.temperature,
            precipitationChance: d.precipitationChance,
            windSpeed: d.windSpeed,
            condition: d.condition
        )
    }
}

// MARK: - Widget configuration

struct OlVaerWidget: Widget {
    let kind = "OlVaerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BeerWeatherProvider()) { entry in
            OlVaerWidgetEntryView(entry: entry)
                .containerBackground(
                    entry.isGood
                        ? Color(red: 0.98, green: 0.97, blue: 0.95)
                        : Color(red: 0.93, green: 0.95, blue: 0.96),
                    for: .widget
                )
        }
        .configurationDisplayName("Øl Vær")
        .description("Sjekk om det er øl-vær der du er.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct OlVaerWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: BeerWeatherEntry

    var body: some View {
        switch family {
        case .systemSmall:  SmallWidgetView(entry: entry)
        case .systemMedium: MediumWidgetView(entry: entry)
        default:            LargeWidgetView(entry: entry)
        }
    }
}
