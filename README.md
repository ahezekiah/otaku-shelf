# OtakuShelf

OtakuShelf is a cross-platform Flutter application for discovering manga and anime, viewing details, saving favorites, writing personal reviews, and switching between light and dark themes.

The project uses the Open Library API for book and manga-style searches and the Jikan API for top anime data. Favorites, reviews, and theme preferences are stored locally on the device using SharedPreferences, so the app does not require a user account, backend server, or database.

---

## Features

- Animated splash screen
- Manga and book search
- Top anime discovery
- Open Library API integration
- Jikan API integration
- Cover image display
- Anime score display
- Detail pages
- Add and remove favorites
- Save personal reviews
- Local data persistence
- Light and dark themes
- Bottom navigation
- Material 3 interface
- Cross-platform Flutter support

---

## Technology Stack

- Flutter
- Dart
- Material 3
- Riverpod
- GoRouter
- SharedPreferences
- HTTP
- Cached Network Image
- Google Fonts
- Lottie
- Open Library API
- Jikan API

---

## How the App Works

The application starts on an animated splash screen and then navigates to the Discover page.

From Discover, users can search Open Library for books and manga-related titles or browse top anime retrieved from Jikan.

Selecting a result opens the Detail page, where the user can save the item to Favorites and write a personal review.

Favorites, reviews, and theme settings are stored locally with SharedPreferences.

Main navigation includes:

- Discover
- Favorites
- Settings

---

## Main Screens

### Splash Page

Located at:

```text
lib/ui/pages/splash_page.dart
```

Displays the OtakuShelf splash animation and automatically navigates to `/discover`.

### Discover Page

Located at:

```text
lib/ui/pages/discover_page.dart
```

Provides:

- Search input
- Open Library search results
- Top anime results
- Network images
- Anime score chips
- Bottom navigation

### Detail Page

Located at:

```text
lib/ui/pages/detail_page.dart
```

Displays the selected item and allows users to:

- View its image and title
- Add it to Favorites
- Remove it from Favorites
- Write a personal review
- Save or update the review

### Favorites Page

Located at:

```text
lib/ui/pages/favorites_page.dart
```

Displays locally saved items and allows users to remove them or open them again.

### Settings Page

Located at:

```text
lib/ui/pages/settings_page.dart
```

Provides a dark-mode toggle and an About dialog.

---

## APIs

### Open Library

Service file:

```text
lib/data/services/open_library_service.dart
```

Used for manga and book-style searches.

Example endpoint:

```text
https://openlibrary.org/search.json?q=SEARCH_TERM&limit=20
```

Search results are converted into `Book` objects.

### Jikan

Service file:

```text
lib/data/services/jikan_service.dart
```

Used for top anime data.

Endpoint:

```text
https://api.jikan.moe/v4/top/anime?limit=20
```

Results are converted into `Anime` objects.

---

## Local Storage

OtakuShelf uses SharedPreferences for local persistence.

Stored data includes:

- Dark mode preference
- Favorites
- Personal reviews

The main preference logic is located in:

```text
lib/state/app_prefs.dart
```

No remote database or user account is required.

---

## State Management

Riverpod is used for application state.

Important providers include:

- `appPrefsProvider`
- `themeModeProvider`
- `favoritesProvider`

Search-related state is also defined in:

```text
lib/state/search_controller.dart
```

---

## Navigation

Navigation is managed with GoRouter.

Router configuration:

```text
lib/router.dart
```

Routes include:

| Route | Page |
| --- | --- |
| `/splash` | Splash Page |
| `/discover` | Discover Page |
| `/favorites` | Favorites Page |
| `/settings` | Settings Page |
| `/detail` | Detail Page |

---

## Project Structure

```text
otaku-shelf-master/
├── assets/
│   └── lottie/
│       └── splash.json
├── lib/
│   ├── main.dart
│   ├── router.dart
│   ├── theme.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── anime.dart
│   │   │   └── book.dart
│   │   └── services/
│   │       ├── jikan_service.dart
│   │       └── open_library_service.dart
│   ├── state/
│   │   ├── app_prefs.dart
│   │   ├── favorites_controller.dart
│   │   └── search_controller.dart
│   └── ui/
│       ├── pages/
│       │   ├── splash_page.dart
│       │   ├── discover_page.dart
│       │   ├── detail_page.dart
│       │   ├── favorites_page.dart
│       │   └── settings_page.dart
│       └── widgets/
│           ├── bottom_nav.dart
│           ├── network_image_card.dart
│           └── rating_chip.dart
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
├── pubspec.yaml
├── pubspec.lock
└── analysis_options.yaml
```

---

## Running the Project Locally

### Requirements

Install:

- Flutter SDK
- Dart SDK
- Git
- VS Code or Android Studio

For Android development, also install:

- Android SDK
- Android SDK Platform Tools
- Android Emulator

### Clone the Repository

```bash
git clone <repository-url>
cd otaku-shelf-master
```

If you downloaded the project as a ZIP, extract it and open the extracted folder.

### Install Dependencies

```bash
flutter pub get
```

### Check Flutter Setup

```bash
flutter doctor
```

### View Available Devices

```bash
flutter devices
```

### Run the App

```bash
flutter run
```

---

## Run on Android

List emulators:

```bash
flutter emulators
```

Launch an emulator:

```bash
flutter emulators --launch YOUR_EMULATOR_ID
```

Then run:

```bash
flutter run
```

You can also specify the device:

```bash
flutter run -d DEVICE_ID
```

---

## Run on Web

```bash
flutter run -d chrome
```

Or:

```bash
flutter run -d web-server
```

---

## Run on Windows

```bash
flutter run -d windows
```

---

## Run on macOS

```bash
flutter run -d macos
```

---

## Run on Linux

```bash
flutter run -d linux
```

---

## Run on iOS

On macOS with Xcode installed:

```bash
flutter devices
flutter run -d DEVICE_ID
```

---

## Build Android APK

Debug:

```bash
flutter build apk --debug
```

Output:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Release:

```bash
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Build for Web

```bash
flutter build web
```

Output:

```text
build/web
```

---

## Important Files

| File | Purpose |
| --- | --- |
| `lib/main.dart` | Starts the Flutter app |
| `lib/router.dart` | Defines routes |
| `lib/theme.dart` | Defines light and dark themes |
| `lib/data/models/book.dart` | Open Library book model |
| `lib/data/models/anime.dart` | Jikan anime model |
| `lib/data/services/open_library_service.dart` | Open Library API requests |
| `lib/data/services/jikan_service.dart` | Jikan API requests |
| `lib/state/app_prefs.dart` | Favorites and theme persistence |
| `lib/ui/pages/discover_page.dart` | Main discovery screen |
| `lib/ui/pages/detail_page.dart` | Item details and review form |
| `lib/ui/pages/favorites_page.dart` | Saved favorites |
| `lib/ui/pages/settings_page.dart` | Theme settings |
| `assets/lottie/splash.json` | Splash animation |

---

## Current Limitations

- The Discover page's top section uses the Jikan top-anime endpoint even though some wording refers to manga.
- Open Library is a general book API, so search results are not guaranteed to be manga only.
- Favorites and reviews are stored only on the local device.
- There is no login or cloud synchronization.
- Detail pages contain limited metadata compared with the source APIs.
- API failures do not yet provide detailed user-facing error messages.
- Pagination is not currently implemented.

---

## Future Improvements

Possible improvements include:

- Separate manga and anime sections
- Add a dedicated manga API
- Add synopsis and genre information
- Add publication dates
- Add chapter and episode counts
- Add favorite sorting and filtering
- Add review editing
- Add search history
- Add pagination
- Add offline caching
- Add authentication
- Add cloud-based favorites and reviews
- Add user profiles
- Add custom shelves such as Reading, Completed, Watching, and Plan to Read
- Improve error handling
- Add automated tests
- Improve responsive layouts

---

## Summary

OtakuShelf is a Flutter-based manga and anime discovery application that combines Open Library search, Jikan anime data, Riverpod state management, GoRouter navigation, SharedPreferences persistence, and Material 3 styling.

Users can search for titles, browse anime, open detail pages, save favorites, write personal reviews, and switch between light and dark themes.

The project can be run locally with Flutter on Android, web, Windows, macOS, Linux, or iOS depending on the development environment.
