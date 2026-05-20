//
//  ContentView.swift
//  Beer weather
//
//  Created by Bjørn Eide on 20/05/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            .tabItem { Label("Hjem", systemImage: "house") }

            NavigationStack {
                MapView()
            }
            .tabItem { Label("Kart", systemImage: "map") }

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Innstillinger", systemImage: "gearshape") }
        }
        .environmentObject(appState)
        .tint(Theme.beerAmber)
    }
}

#Preview {
    ContentView()
}
