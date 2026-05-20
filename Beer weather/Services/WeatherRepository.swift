import WeatherKit
import CoreLocation

actor WeatherRepository {
    static let shared = WeatherRepository()
    private let service = WeatherService.shared

    func fetch(for location: CLLocation) async throws -> WeatherSnapshot {
        let weather = try await service.weather(for: location)
        let current = weather.currentWeather
        let precipChance = weather.hourlyForecast.forecast.first?.precipitationChance ?? 0

        return WeatherSnapshot(
            temperature: current.temperature.converted(to: .celsius).value,
            precipitationChance: precipChance,
            windSpeed: current.wind.speed.converted(to: .metersPerSecond).value,
            condition: map(current.condition),
            locationName: ""
        )
    }

    private func map(_ condition: WeatherCondition) -> WeatherSnapshot.Condition {
        switch condition {
        case .clear, .mostlyClear:
            return .sunny
        case .partlyCloudy, .mostlyCloudy:
            return .partlyCloudy
        case .cloudy, .foggy, .haze, .smoky, .breezy, .windy:
            return .cloudy
        case .rain, .drizzle, .heavyRain, .isolatedThunderstorms, .thunderstorms,
             .tropicalStorm, .hurricane, .scatteredThunderstorms:
            return .rainy
        case .snow, .flurries, .heavySnow, .blizzard, .sleet,
             .freezingDrizzle, .freezingRain, .wintryMix:
            return .snowy
        default:
            return .cloudy
        }
    }
}
