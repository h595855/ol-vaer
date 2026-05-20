import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            content
        }
        .onAppear { appState.start() }
    }

    // MARK: - Background

    private var isGood: Bool {
        if case .loaded = appState.phase, let s = appState.score { return s.tier.isGood }
        return false
    }

    private var background: Color {
        isGood ? Theme.warmBg : Theme.coldBg
    }

    // MARK: - Content switch

    @ViewBuilder
    private var content: some View {
        switch appState.phase {
        case .idle, .loading:
            loadingView
        case .locationDenied:
            locationDeniedView
        case .error(let msg):
            errorView(message: msg)
        case .loaded:
            if let snap = appState.snapshot, let score = appState.score {
                loadedView(snapshot: snap, score: score)
            }
        }
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: Theme.spacingM) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Theme.textSecondary)
            Text("Sjekker været…")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    // MARK: - Location denied

    private var locationDeniedView: some View {
        VStack(spacing: Theme.spacingL) {
            Image(systemName: "location.slash")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textSecondary)
            Text("Lokasjon ikke tilgjengelig")
                .font(.title3.bold())
                .foregroundStyle(Theme.textPrimary)
            Text("Aktiver stedstjenester i Innstillinger for å sjekke øl-vær.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.spacingXL)
            Button("Åpne Innstillinger") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.spacingXL)
        }
    }

    // MARK: - Error

    private func errorView(message: String) -> some View {
        VStack(spacing: Theme.spacingL) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textSecondary)
            Text("Noe gikk galt")
                .font(.title3.bold())
                .foregroundStyle(Theme.textPrimary)
            Text(message)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.spacingXL)
            Button("Prøv igjen") { appState.refresh() }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, Theme.spacingXL)
        }
    }

    // MARK: - Loaded

    private func loadedView(snapshot: WeatherSnapshot, score: BeerScore) -> some View {
        VStack(spacing: 0) {
            // Location header
            HStack {
                Text(snapshot.locationName.isEmpty ? "Din lokasjon" : snapshot.locationName.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.6)
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Button { appState.refresh() } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(.horizontal, Theme.spacingL)
            .padding(.top, Theme.spacingL)

            Spacer()

            // Hero: animated beer glass
            BeerGlassView(fillFraction: CGFloat(score.value) / 100.0)
                .frame(width: 140, height: 220)

            Spacer(minLength: Theme.spacingXL)

            // Status labels
            Text(score.tier.label)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(score.tier.isGood ? Theme.beerAmber : Theme.textSecondary)
                .animation(Theme.ease, value: score.tier.isGood)

            Text(score.tier.sublabel)
                .font(.system(size: 15))
                .foregroundStyle(Theme.textSecondary)
                .padding(.top, Theme.spacingXS)

            Spacer(minLength: Theme.spacingXL)

            // Weather stats pills
            WeatherStatsRow(snapshot: snapshot)
                .padding(.horizontal, Theme.spacingL)

            Spacer(minLength: Theme.spacingL)

            // Navigate to map
            NavigationLink {
                MapView()
            } label: {
                Text("Se beste steder")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, Theme.spacingL)

            Spacer(minLength: 52)
        }
    }
}
