import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedSpot: BeerSpot?
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $cameraPosition, selection: $selectedSpot) {
                UserAnnotation()
                ForEach(viewModel.spots) { spot in
                    Annotation(spot.name, coordinate: spot.coordinate, anchor: .bottom) {
                        SpotAnnotationView(spot: spot, score: appState.score?.value)
                    }
                    .tag(spot)
                }
            }
            .mapStyle(.standard(emphasis: .muted))
            .ignoresSafeArea(edges: .bottom)

            if let spot = selectedSpot {
                SpotDetailCard(spot: spot, score: appState.score?.value ?? 0)
                    .padding(.horizontal, Theme.spacingL)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle("Beste steder")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedSpot)
        .onAppear {
            viewModel.loadSpots(near: appState.userLocation)
            if let loc = appState.userLocation {
                cameraPosition = .region(MKCoordinateRegion(
                    center: loc.coordinate,
                    latitudinalMeters: 12_000,
                    longitudinalMeters: 12_000
                ))
            }
        }
    }
}

private struct SpotDetailCard: View {
    let spot: BeerSpot
    let score: Int

    private var isGood: Bool { score > 60 }

    var body: some View {
        HStack(alignment: .center, spacing: Theme.spacingM) {
            VStack(alignment: .leading, spacing: 4) {
                Text(spot.name)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Text(spot.description)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(2)
            }
            Spacer()
            Text("\(score)")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(isGood ? Theme.beerAmber : Theme.textSecondary)
        }
        .padding(Theme.spacingL)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerL)
                .fill(.regularMaterial)
        )
    }
}
