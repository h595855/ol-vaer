import Foundation

struct BeerScoreService {

    // Weights:  temperature 50 pts  |  precipitation 30 pts  |  wind 20 pts
    func calculate(from weather: WeatherSnapshot) -> BeerScore {
        let total = tempScore(weather.temperature)
                  + rainScore(weather.precipitationChance)
                  + windScore(weather.windSpeed)
        return BeerScore(value: max(0, min(100, total)))
    }

    private func tempScore(_ t: Double) -> Int {
        switch t {
        case ..<10:   return 0
        case 10..<16: return Int((t - 10) / 6.0 * 20)
        case 16..<25: return Int(20 + (t - 16) / 9.0 * 30)
        case 25..<30: return 50
        default:      return max(0, Int(50 - (t - 30) * 4))
        }
    }

    private func rainScore(_ chance: Double) -> Int {
        Int(max(0, 30.0 * (1.0 - chance / 0.6)))
    }

    private func windScore(_ speed: Double) -> Int {
        switch speed {
        case ..<5:  return 20
        case 5..<10: return 10
        default:    return 0
        }
    }
}
