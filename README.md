# tracker

Mobile app (Flutter) to keep track of company reimbursements.

For now it is a skeleton: add expenses with purchase date, total amount,
category (meals, grocery shop) and optional notes. Data is stored locally in
SQLite via [drift](https://drift.simonbinder.eu); there is no remote backend.

## Development

```
flutter pub get
dart run build_runner build   # generates *.g.dart (drift)
flutter gen-l10n              # generated automatically on build
flutter test
flutter run
```

Structure follows `booktracker`: `lib/core` (database, l10n), `lib/features/expenses`
(`domain`, `data`, `presentation`). UI languages: Italian (default) and English.
