# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & run

This is a native iOS app — there is no package manager or build script. All building happens through Xcode or `xcodebuild`.

```bash
# Build the main app (requires simulator runtime installed)
xcodebuild -project "Beer weather.xcodeproj" -scheme "Beer weather" -destination "platform=iOS Simulator,name=iPhone 16" build

# Run tests
xcodebuild -project "Beer weather.xcodeproj" -scheme "Beer weather" -destination "platform=iOS Simulator,name=iPhone 16" test

# Run a single test class
xcodebuild -project "Beer weather.xcodeproj" -scheme "Beer weather" -destination "platform=iOS Simulator,name=iPhone 16" -only-testing "Beer weatherTests/SomeTestClass" test
```

WeatherKit does **not** work on the simulator — only on a real device with the WeatherKit capability enabled.

## Architecture

The app uses a single `AppState` object (injected as `@EnvironmentObject` from `ContentView`) as the sole source of truth. All data flows one way:

```
AppState
  └── LocationService  (CoreLocation → CLLocation + city name)
  └── WeatherRepository (WeatherKit → WeatherSnapshot)
  └── BeerScoreService  (WeatherSnapshot → BeerScore 0–100)
  └── SharedDataService (writes to App Group UserDefaults → Widget reads)
```

`AppState` publishes `phase: Phase` (`.idle / .loading / .loaded / .locationDenied / .error`), `snapshot: WeatherSnapshot?`, and `score: BeerScore?`. Views switch on `phase` and never call services directly.

## Widget data sharing

The widget extension reads weather data via `SharedDataService.load()` which reads from the App Group `group.no.bjorneide.olveer`. The main app writes via `SharedDataService.save()` after every successful weather fetch, then calls `WidgetCenter.shared.reloadAllTimelines()`.

Four files must be compiled in **both** the main app target and the widget extension target:
- `Models/BeerScore.swift`
- `Models/WeatherSnapshot.swift`
- `Models/SharedWeatherData.swift`
- `Services/SharedDataService.swift`

## Beer score formula

`BeerScoreService` produces a 0–100 integer:
- Temperature: 0–50 pts (peaks at 25–30 °C, zero below 10 °C)
- Rain chance: 0–30 pts (linear, zero at ≥ 60% chance)
- Wind speed: 20 / 10 / 0 pts for < 5 / 5–10 / > 10 m/s

Tiers: **Øl-tid!** (81–100) · **Godt vær** (61–80) · **Ta med jakke** (31–60) · **Bli inne** (0–30)

## Key capabilities required

Both targets need these Xcode capabilities configured:
- **WeatherKit** — also requires enabling per App ID at developer.apple.com
- **App Groups** — ID: `group.no.bjorneide.olveer`

Main app also needs **Location When In Use**.

## Design system

All colours, spacing constants, and animation presets live in `Theme.swift`. The app has two background states: `Theme.warmBg` (good weather) and `Theme.coldBg` (bad weather), toggled via `AppState.score.tier.isGood`. The single accent colour is `Theme.beerAmber`.

The beer glass (`BeerGlassView`) is drawn with SwiftUI `Canvas` using a `drawLayer` clip so the amber fill stays inside the glass outline. `WidgetBeerGlassView` is a static (non-animated) copy for the widget extension.
