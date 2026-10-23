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

## Run and validate

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```
