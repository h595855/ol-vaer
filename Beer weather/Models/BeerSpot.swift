import Foundation
import CoreLocation

struct BeerSpot: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let type: SpotType
    let city: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: BeerSpot, rhs: BeerSpot) -> Bool { lhs.id == rhs.id }

    enum SpotType: String, Codable {
        case park, waterfront, terrace, square, viewpoint
    }
}
