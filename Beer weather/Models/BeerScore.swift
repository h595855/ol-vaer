import Foundation

struct BeerScore: Codable {
    let value: Int  // 0–100

    var tier: Tier {
        switch value {
        case 81...100: return .perfect
        case 61...80:  return .good
        case 31...60:  return .marginal
        default:       return .poor
        }
    }

    enum Tier {
        case perfect, good, marginal, poor

        var label: String {
            switch self {
            case .perfect:  return "Øl-tid!"
            case .good:     return "Godt vær"
            case .marginal: return "Ta med jakke"
            case .poor:     return "Bli inne"
            }
        }

        var sublabel: String {
            switch self {
            case .perfect:  return "Perfekt for en is kald øl ute"
            case .good:     return "Hyggelig å sitte ute"
            case .marginal: return "Kanskje litt friskt"
            case .poor:     return "Bedre med en inne-øl i dag"
            }
        }

        var isGood: Bool { self == .good || self == .perfect }
    }
}
