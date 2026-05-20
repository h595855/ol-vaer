import Foundation
import CoreLocation

@MainActor
final class MapViewModel: ObservableObject {
    @Published var spots: [BeerSpot] = []

    func loadSpots(near location: CLLocation?) {
        guard let url = Bundle.main.url(forResource: "BeerSpots", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let all = try? JSONDecoder().decode([BeerSpot].self, from: data)
        else { return }

        guard let location else {
            spots = all
            return
        }

        let nearby = all.filter { spot in
            let loc = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            return location.distance(from: loc) <= 60_000
        }
        spots = nearby.isEmpty ? all : nearby
    }
}
