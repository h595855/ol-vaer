import Foundation

// Codable bridge shared between the main app target and the Widget extension.
struct SharedWeatherData: Codable {
    let score: Int
    let locationName: String
    let temperature: Double
    let precipitationChance: Double
    let windSpeed: Double
    let condition: String   // WeatherSnapshot.Condition.rawValue
    let updatedAt: Date
}
