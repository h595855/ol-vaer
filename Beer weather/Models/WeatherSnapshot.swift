import Foundation

struct WeatherSnapshot {
    let temperature: Double          // °C
    let precipitationChance: Double  // 0–1
    let windSpeed: Double            // m/s
    let condition: Condition
    let locationName: String

    enum Condition: String, Codable, CaseIterable {
        case sunny, partlyCloudy, cloudy, rainy, snowy

        var sfSymbol: String {
            switch self {
            case .sunny:        return "sun.max.fill"
            case .partlyCloudy: return "cloud.sun.fill"
            case .cloudy:       return "cloud.fill"
            case .rainy:        return "cloud.rain.fill"
            case .snowy:        return "cloud.snow.fill"
            }
        }
    }
}
