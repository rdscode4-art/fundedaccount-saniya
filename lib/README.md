# FundX Trading App — lib/

This is the complete `lib/` folder for the FundX funded-trading app UI, built with
**GetX** (state management + routing + DI) and **mock repositories** (easy to swap
for a real API later).

## Setup

1. Copy this entire `lib` folder into your Flutter project, replacing the
   default one that `flutter create` generated.
2. Make sure your `pubspec.yaml` has these dependencies (you said you've
   already added them — double check versions are close to these):

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  fl_chart: ^0.69.0
  google_fonts: ^6.2.1
  intl: ^0.19.0
  shared_preferences: ^2.3.2
  percent_indicator: ^4.2.3
```

(`flutter_svg` is optional — nothing in this build currently requires it, but
you can add it later for custom SVG icons.)

3. Run:
```bash
flutter pub get
flutter run
```

## What's included

- `app/` — theme (dark, matches the mockup), routes, and global DI binding
- `core/` — shared widgets (bottom nav, cards, progress bar) and formatters
- `data/` — models + repository interfaces + mock implementations
- `modules/` — one folder per screen (splash, onboarding, auth, dashboard,
  choose_account, account_details, trade_chart, new_order, wallet,
  history, profile), each with its own `_view.dart`, `_controller.dart`, and
  `_binding.dart`

## Flow

Splash → Onboarding → Login/Register → Dashboard → (Choose Account /
Account Details / Trade+Chart / New Order / Wallet / History / Profile)

## Swapping mock data for a real API later

Every screen depends only on an abstract repository interface
(`AuthRepository`, `AccountRepository`, `TradingRepository`,
`WalletRepository`), never directly on the mock class. To connect a real
backend:

1. Create e.g. `AccountRepositoryHttp implements AccountRepository`.
2. In `lib/app/bindings/initial_binding.dart`, change:
   ```dart
   Get.put<AccountRepository>(AccountRepositoryMock(), permanent: true);
   ```
   to:
   ```dart
   Get.put<AccountRepository>(AccountRepositoryHttp(), permanent: true);
   ```

No controller or view code needs to change.

## Notes / things you may want to polish next

- The candlestick chart on the Trade screen is built with `fl_chart`'s
  `BarChart` (wick + body as adjacent bars) since fl_chart has no native
  candlestick chart type. It's a common workaround and looks close to the
  mockup, but a dedicated candlestick package (e.g. `candlesticks`) would
  give a more polished result if you want to upgrade later.
- Forms (New Order, Login) don't yet have full validation — I kept it light
  since this is UI-first. Add `Form`/`TextFormField` validators before
  shipping.
- No persistence yet (login state resets on app restart) — wire up
  `shared_preferences` in `AuthRepositoryMock`/a real repo when ready.
