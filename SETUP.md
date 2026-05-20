# Øl Vær — Xcode Setup Guide

All Swift source files have been generated. Follow these steps in Xcode to get the project compiling and running.

---

## 1. Add source files to the main app target

Open `Beer weather.xcodeproj` in Xcode. In the Project Navigator, right-click the **Beer weather** group and choose **Add Files to "Beer weather"…**

Add these files/folders (make sure **Target: Beer weather** is checked):

```
Beer weather/
├── Theme.swift
├── AppState.swift
├── Models/
│   ├── BeerScore.swift
│   ├── WeatherSnapshot.swift
│   ├── BeerSpot.swift
│   └── SharedWeatherData.swift
├── Services/
│   ├── LocationService.swift
│   ├── WeatherRepository.swift
│   ├── BeerScoreService.swift
│   └── SharedDataService.swift
├── ViewModels/
│   └── MapViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── MapView.swift
│   ├── SettingsView.swift
│   └── Components/
│       ├── BeerGlassView.swift
│       ├── WeatherStatsRow.swift
│       ├── SpotAnnotationView.swift
│       └── PrimaryButtonStyle.swift
└── Resources/
    └── BeerSpots.json
```

> **Tip:** you can drag the entire `Models/`, `Services/`, `Views/`, and `ViewModels/` folders straight into the Project Navigator. Xcode will add them and create groups automatically.

---

## 2. Add the Widget Extension target

1. **File → New → Target…** → choose **Widget Extension**
2. Product Name: `Beer weatherWidget`
3. Bundle Identifier: `no.bjorneide.olveer.widget`
4. Uncheck "Include Configuration Intent"
5. Click **Finish** — Xcode asks to activate the scheme, click **Activate**

Xcode creates a `Beer weatherWidget/` folder with a stub file. **Delete the stub** and add the generated files instead:

```
Beer weatherWidget/
├── BeerWeatherWidget.swift
├── WidgetBundle.swift
└── Views/
    ├── WidgetBeerGlassView.swift
    ├── SmallWidgetView.swift
    ├── MediumWidgetView.swift
    └── LargeWidgetView.swift
```

### Shared files (add to BOTH targets)

These four files need to be compiled in both the app and the widget:

| File | How |
|---|---|
| `Beer weather/Models/BeerScore.swift` | Select file → File Inspector → check ✅ `Beer weatherWidget` |
| `Beer weather/Models/WeatherSnapshot.swift` | Same as above |
| `Beer weather/Models/SharedWeatherData.swift` | Same as above |
| `Beer weather/Services/SharedDataService.swift` | Same as above |

---

## 3. Configure capabilities

### Main app target

Select the **Beer weather** target → **Signing & Capabilities** tab, then add:

| Capability | Setting |
|---|---|
| **Location** | (just add it) |
| **WeatherKit** | (just add it) |
| **App Groups** | Add group: `group.no.bjorneide.olveer` |

### Widget target

Select the **Beer weatherWidget** target → **Signing & Capabilities**:

| Capability | Setting |
|---|---|
| **WeatherKit** | (just add it) |
| **App Groups** | Add group: `group.no.bjorneide.olveer` |

---

## 4. Info.plist — location usage description

Select the **Beer weather** target → **Info** tab. Add a row:

| Key | Value |
|---|---|
| `Privacy - Location When In Use Usage Description` | `Øl Vær bruker lokasjonen din for å sjekke øl-vær der du er.` |

---

## 5. Team & Bundle ID

Select the **Beer weather** target → **Signing & Capabilities**:

- **Team**: your Apple Developer account
- **Bundle Identifier**: `no.bjorneide.olveer` (or any valid ID you prefer)

Do the same for the **Beer weatherWidget** target:

- **Bundle Identifier**: `no.bjorneide.olveer.widget`

> If you change the bundle ID prefix, also update `group.no.bjorneide.olveer` everywhere (App Group capability in both targets + the `groupID` constant in `SharedDataService.swift`).

---

## 6. WeatherKit — enable in the Developer Portal

WeatherKit requires an explicit enable per App ID.

1. Go to [developer.apple.com](https://developer.apple.com) → Certificates, IDs & Profiles → Identifiers
2. Find (or create) the App ID for `no.bjorneide.olveer`
3. Enable **WeatherKit** capability
4. Repeat for `no.bjorneide.olveer.widget`
5. Regenerate provisioning profiles if needed

---

## 7. Display name (Norwegian characters)

To show **Øl Vær** as the app name on the home screen:

Select the **Beer weather** target → **Build Settings** → search `INFOPLIST_KEY_CFBundleDisplayName` → set to `Øl Vær`.

Or add to Info.plist: `Bundle display name` = `Øl Vær`.

---

## 8. Run the app

Select the **Beer weather** scheme and a real device (WeatherKit does not work on simulator without a valid subscription). Build & Run.

The widget can be added via long-press → **+** on the home screen after the first launch.

---

## Architecture overview

```
AppState (ObservableObject, @EnvironmentObject)
  ├── LocationService  — CoreLocation GPS + reverse geocode
  ├── WeatherRepository — WeatherKit fetch
  └── BeerScoreService — 0–100 score (temp 50 pts / rain 30 pts / wind 20 pts)
                              ↓ writes
                       SharedDataService → UserDefaults (App Group)
                                                 ↑ reads
                                          BeerWeatherWidget (WidgetKit)
```

## Beer Score tiers

| Score | Label |
|---|---|
| 81–100 | Øl-tid! |
| 61–80 | Godt vær |
| 31–60 | Ta med jakke |
| 0–30 | Bli inne |
