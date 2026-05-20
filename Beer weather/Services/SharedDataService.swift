import Foundation
import WidgetKit

// Writes/reads weather data via App Groups so the Widget extension can access it.
// Add this file to BOTH the main app target and the Widget extension target in Xcode.
enum SharedDataService {
    private static let groupID = "group.no.bjorneide.olveer"
    private static let key = "beerWeatherData"

    static func save(score: BeerScore, snapshot: WeatherSnapshot) {
        let data = SharedWeatherData(
            score: score.value,
            locationName: snapshot.locationName,
            temperature: snapshot.temperature,
            precipitationChance: snapshot.precipitationChance,
            windSpeed: snapshot.windSpeed,
            condition: snapshot.condition.rawValue,
            updatedAt: .now
        )
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        UserDefaults(suiteName: groupID)?.set(encoded, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func load() -> SharedWeatherData? {
        guard let defaults = UserDefaults(suiteName: groupID),
              let encoded = defaults.data(forKey: key),
              let data = try? JSONDecoder().decode(SharedWeatherData.self, from: encoded)
        else { return nil }
        return data
    }
}
