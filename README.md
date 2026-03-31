# PumpLog Flutter (Test-Migration)

Dieses Repo enthält eine erste Flutter-App, die sich an der bestehenden React-UI orientiert:

- Login über **Authentik OIDC**
- Workout-Liste über denselben API-Endpoint (`/api/pumplog/ActiveSessions`)
- Neues Workout anlegen über `POST /api/pumplog`
- Dark UI mit PumpLog-Look (mobile-first)

## Was bereits umgesetzt ist

- Auth-Flow mit `flutter_appauth`
- Token-Speicherung via `flutter_secure_storage`
- API-Client mit Bearer Token
- Workouts Screen + Session Cards + Add-Button

## Build-Parameter (wie Web-Konfiguration)

Per `--dart-define`:

- `API_BASE_URL` (default: `http://localhost:5290/api`)
- `OIDC_AUTHORITY` (default: `https://auth.onlychris.net/application/o/pumplog/`)
- `OIDC_CLIENT_ID` (default: bestehender Web-Client)
- `OIDC_REDIRECT_URL` (default: `com.apfelmannai.pumplog:/oauthredirect`)
- `OIDC_POST_LOGOUT_REDIRECT_URL` (default: `com.apfelmannai.pumplog:/logout`)

## Start (lokal)

```bash
flutter pub get
flutter run \
  --dart-define=API_BASE_URL=https://<dein-host>/api \
  --dart-define=OIDC_AUTHORITY=https://auth.onlychris.net/application/o/pumplog/ \
  --dart-define=OIDC_CLIENT_ID=<client-id> \
  --dart-define=OIDC_REDIRECT_URL=com.apfelmannai.pumplog:/oauthredirect \
  --dart-define=OIDC_POST_LOGOUT_REDIRECT_URL=com.apfelmannai.pumplog:/logout
```

## Build-Ergebnis (aktuell)

- Debug APK erfolgreich gebaut:
  - `build/app/outputs/flutter-apk/app-debug.apk`

## Doku

- Vollständiger Migrationsstand + Techstack:
  - `docs/FLUTTER_MIGRATION.md`
- Mockup Screenshots:
  - `docs/screenshots/login_mock.png`
  - `docs/screenshots/workouts_mock.png`

## Nächster Schritt

- Vollständiger Feature-Port (Analytics/Settings, Exercise-Editing, Reps-Modal)
- Release-Signing + Release APK/AAB
