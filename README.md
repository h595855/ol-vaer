# Øl Vær

An iOS app that tells you if the weather is good enough for a cold beer outside.

Built for Bergen — a city where the sun deserves a celebration.

---

## Features

- **Beer score 0–100** calculated from temperature, rain chance, and wind speed
- **Animated beer glass** that fills up with amber as conditions improve
- **Map with curated outdoor spots** — Bryggen, Torgallmenningen, Nordnes and more, across Bergen, Oslo, Trondheim, Stavanger, Stockholm, and Copenhagen
- **Home screen widgets** in small, medium, and large — golden beer and sun when it's time, empty glass when it's not
- **GPS-based** — works anywhere in the world, not just Norway
- Scandi minimalist design — warm off-white when good, cool grey when not

---

## Beer Score

| Score | Verdict |
|---|---|
| 81–100 | Øl-tid! |
| 61–80 | Godt vær |
| 31–60 | Ta med jakke |
| 0–30 | Bli inne |

**Scoring breakdown:**

| Factor | Max points | Sweet spot |
|---|---|---|
| Temperature | 50 | 25–30 °C |
| Rain chance | 30 | < 10% |
| Wind speed | 20 | < 5 m/s |

---

## Tech stack

- **SwiftUI** — UI and animations
- **WeatherKit** — live weather data (requires Apple Developer account)
- **CoreLocation** — GPS + reverse geocoding
- **MapKit** — outdoor spots map
- **WidgetKit** — home screen and lock screen widgets
- **App Groups** — shared data between app and widget

Minimum deployment: **iOS 17**

---

## Project structure

```
Beer weather/
├── AppState.swift              Single source of truth (location → weather → score)
├── Theme.swift                 Design system (colours, spacing, animation)
├── Models/                     BeerScore · WeatherSnapshot · BeerSpot · SharedWeatherData
├── Services/
│   ├── LocationService.swift   CoreLocation wrapper
│   ├── WeatherRepository.swift WeatherKit wrapper
│   ├── BeerScoreService.swift  Score algorithm
│   └── SharedDataService.swift App Groups bridge to widget
├── ViewModels/
│   └── MapViewModel.swift
└── Views/
    ├── HomeView.swift          Main screen with animated glass
    ├── MapView.swift           Curated spots on Apple Maps
    ├── SettingsView.swift      °C/°F toggle, custom threshold
    └── Components/
        ├── BeerGlassView.swift  Animated Canvas-drawn beer mug
        ├── WeatherStatsRow.swift
        ├── SpotAnnotationView.swift
        └── PrimaryButtonStyle.swift

Beer weatherWidget/
├── BeerWeatherWidget.swift     TimelineProvider, refreshes every 30 min
└── Views/
    ├── SmallWidgetView.swift
    ├── MediumWidgetView.swift
    └── LargeWidgetView.swift
```

---

## Setup

See [SETUP.md](SETUP.md) for the full Xcode configuration guide, including:

- Adding source files to targets
- Adding the Widget Extension target
- Configuring WeatherKit, App Groups, and Location capabilities
- Enabling WeatherKit in the Apple Developer Portal

WeatherKit requires a paid Apple Developer account and does not work on the simulator.

---

## Outdoor spots

The app ships with 22 curated outdoor drinking spots across 6 cities:

| City | Spots |
|---|---|
| Bergen | Bryggen · Torgallmenningen · Nordnes Park · Nøstet · Muséplassen · Fløyen |
| Oslo | Aker Brygge · Youngstorget · Vigelandsparken · Sørenga · Grünerløkka |
| Trondheim | Nedre Elvehavn · Solsiden · Nedre Møllenberg |
| Stavanger | Gamle Stavanger · Vågen havn |
| Stockholm | Djurgården · Kungsträdgården · Södermalm-terrassen |
| Copenhagen | Nyhavn · Islands Brygge |

Spots are filtered to within 60 km of the user's current location. If no spots are nearby, all are shown.
