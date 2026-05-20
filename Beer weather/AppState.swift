import SwiftUI
import CoreLocation
import Combine

@MainActor
final class AppState: ObservableObject {

    enum Phase: Equatable {
        case idle, loading, loaded, locationDenied, error(String)
    }

    @Published var phase: Phase = .idle
    @Published var snapshot: WeatherSnapshot?
    @Published var score: BeerScore?
    @Published var userLocation: CLLocation?

    var locationName: String { locationService.locationName }

    private let locationService = LocationService()
    private let scoreService = BeerScoreService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        locationService.$location
            .compactMap { $0 }
            .removeDuplicates { a, b in a.distance(from: b) < 500 }
            .sink { [weak self] loc in
                self?.userLocation = loc
                Task { await self?.fetchWeather(for: loc) }
            }
            .store(in: &cancellables)

        locationService.$authorizationStatus
            .filter { $0 == .denied || $0 == .restricted }
            .sink { [weak self] _ in self?.phase = .locationDenied }
            .store(in: &cancellables)
    }

    func start() {
        guard phase == .idle else { return }
        phase = .loading
        locationService.requestLocation()
    }

    func refresh() {
        phase = .loading
        locationService.requestLocation()
    }

    private func fetchWeather(for location: CLLocation) async {
        do {
            let raw = try await WeatherRepository.shared.fetch(for: location)
            let snap = WeatherSnapshot(
                temperature: raw.temperature,
                precipitationChance: raw.precipitationChance,
                windSpeed: raw.windSpeed,
                condition: raw.condition,
                locationName: locationService.locationName
            )
            let beerScore = scoreService.calculate(from: snap)
            snapshot = snap
            score = beerScore
            phase = .loaded
            SharedDataService.save(score: beerScore, snapshot: snap)
        } catch {
            phase = .error(error.localizedDescription)
        }
    }
}
