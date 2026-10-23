# Passwd Hints

Passwd Hints keeps account names, optional usernames, and password hints in a
local list. It is a hint organizer, not a password manager.

## Features

- Add, edit, search, and remove hints.
- Browse entries alphabetically, including numeric and special-character names.
- Import and export the entry data as JSON.
- Follow the system light or dark appearance.

Application data is stored in the platform's documents directory in
`passwd_hints_data.json`.

## Android environments

Android has two flavors that use the same Flutter application:

- **Development** (`dev`): installs as `com.passwd_hints.dev` and is labeled
  **Passwd Hints Dev**.
- **Production** (`prod`): retains the existing ID `com.passwd_hints` and
  **Passwd Hints** label.

Run the development app on a connected device or emulator:

```sh
flutter run --flavor dev --dart-define=APP_ENV=dev
```

Build either APK:

```sh
flutter build apk --flavor dev --dart-define=APP_ENV=dev
flutter build apk --flavor prod --release --dart-define=APP_ENV=prod
```

Since the existing production app is already installed, install only the dev
APK to add the development app without touching production:

```sh
adb install -r build/app/outputs/flutter-apk/app-dev-release.apk
```

On a device without the existing production app, both APKs can be installed:

```sh
adb install -r build/app/outputs/flutter-apk/app-dev-release.apk
adb install -r build/app/outputs/flutter-apk/app-prod-release.apk
```

Installing the production APK updates the existing `com.passwd_hints`
installation and requires a matching signing certificate. Do not uninstall the
existing app to resolve a signature mismatch.

The separate application IDs isolate Android-private files, including the
local hints JSON file. Importing or exporting a file uses a user-selected
location and can therefore be shared deliberately. The app currently has no
backend URL or API client configured. If one is added, supply an environment's
URL with `--dart-define=API_BASE_URL=<environment-url>`; this setting is
available through `AppConfig` and must not contain secrets.

In VS Code, select **Passwd Hints (Development)** or
**Passwd Hints (Production)** from the Run and Debug configuration list. The
production release build currently uses Android's debug signing key because
that is the existing Gradle configuration. Before distributing production
updates, configure the original production signing key; otherwise, an APK
signed with a different key cannot update an existing installation.

The iOS target still has a single Runner bundle identifier and display name.
Supporting co-installed iOS flavors would additionally require separate Xcode
schemes/configurations, bundle identifiers, and display-name settings; this
change leaves iOS unchanged.

## Run and validate

```sh
flutter pub get
flutter run --flavor dev --dart-define=APP_ENV=dev
flutter analyze
flutter test
```
