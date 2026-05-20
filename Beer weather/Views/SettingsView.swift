import SwiftUI

struct SettingsView: View {
    @AppStorage("useFahrenheit") private var useFahrenheit = false
    @AppStorage("beerThreshold") private var beerThreshold: Double = 60

    var body: some View {
        List {
            Section("Temperatur") {
                Toggle(isOn: $useFahrenheit) {
                    Label("Bruk Fahrenheit", systemImage: "thermometer.medium")
                }
                .tint(Theme.beerAmber)
            }

            Section {
                VStack(alignment: .leading, spacing: Theme.spacingS) {
                    HStack {
                        Text("Minstescore for øl-vær")
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        Text("\(Int(beerThreshold))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Theme.beerAmber)
                    }
                    Slider(value: $beerThreshold, in: 30...90, step: 5)
                        .tint(Theme.beerAmber)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Terskelverdi")
            } footer: {
                Text("Øl Vær markerer det som øl-tid når scoren er over dette.")
            }

            Section("Om appen") {
                HStack {
                    Text("Versjon")
                    Spacer()
                    Text("1.0")
                        .foregroundStyle(Theme.textSecondary)
                }
                HStack {
                    Text("Vær fra")
                    Spacer()
                    Text("Apple WeatherKit")
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .navigationTitle("Innstillinger")
        .listStyle(.insetGrouped)
    }
}
