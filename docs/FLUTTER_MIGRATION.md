# PumpLog Flutter – Stand der Migration (Android)

## Ziel
React-Frontend in eine Flutter-Android-App überführen, bei gleicher API und gleichem Auth-Backend (Authentik/OIDC).

## Aktueller Stand

### Bereits umgesetzt
- Flutter-Projekt (Android)
- OIDC Login mit `flutter_appauth`
- Token-Persistenz mit `flutter_secure_storage`
- API-Integration gegen PumpLog Backend
  - `GET /api/pumplog/ActiveSessions`
  - `POST /api/pumplog` (neues Workout)
- Mobile-first UI
  - Login-Screen
  - Workouts-Liste
  - Session Cards
  - Refresh + Logout + FAB (neues Workout)
- Android Redirect-Scheme für AppAuth:
  - `com.apfelmannai.pumplog:/oauthredirect`
  - `com.apfelmannai.pumplog:/logout`
- Debug-APK erfolgreich gebaut

### Build-Artefakt
- Lokaler Pfad: `build/app/outputs/flutter-apk/app-debug.apk`

## Verwendete Konfiguration

### Auth (wie vorgegeben)
- Authority: `https://auth.onlychris.net`
- Issuer: `https://auth.onlychris.net/application/o/pumplog/`
- Audience/ClientId: `Se0ZrV0vLDMTrO2MTqS6iQk1Y7G1pvYaLpJMysRv`

### API
- Basis (Build-Define): `https://pumplog.onlychris.net/api`

## Tech Stack
- Flutter `3.24.3`
- Dart `3.5.3`
- State Management: `flutter_riverpod`
- Networking: `http`
- Auth: `flutter_appauth`
- Secure Storage: `flutter_secure_storage`
- JWT Handling: `jwt_decoder`

## Projektstruktur (relevant)
- `lib/core/app_config.dart` – Runtime-Config über `--dart-define`
- `lib/services/auth_service.dart` – OIDC Login/Refresh/Logout
- `lib/services/token_storage.dart` – sichere Token-Ablage
- `lib/services/pumplog_api.dart` – API-Calls
- `lib/state/auth_controller.dart` – Auth-State (Riverpod)
- `lib/state/workouts_controller.dart` – Workouts-State (Riverpod)
- `lib/ui/screens/login_screen.dart` – Login UI
- `lib/ui/screens/workouts_screen.dart` – Workouts UI
- `lib/ui/widgets/session_card.dart` – Session Card

## Android-Hinweise
- Application ID / Namespace:
  - `com.apfelmannai.pumplog`
- AppAuth Redirect Placeholder in Gradle gesetzt:
  - `appAuthRedirectScheme = com.apfelmannai.pumplog`

## Mockup-Screenshots
- `docs/screenshots/login_mock.png`
- `docs/screenshots/workouts_mock.png`

## Nächste Iterationen
1. Vollständiger Feature-Port (Analytics, Settings, Exercise-Editor, Reps-Dialog)
2. UI-Feinschliff 1:1 zum Web-Design
3. Error-Handling + Retry-Strategie + Session-Restore edge cases
4. Release-Signing + Release-APK/AAB Pipeline
