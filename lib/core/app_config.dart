class AppConfig {
  // Gleich wie Web: lokal -> localhost api, sonst origin-ähnlich per Build-Config.
  // Für Mobile i.d.R. per --dart-define setzen.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5290/api',
  );

  static const oidcAuthority = String.fromEnvironment(
    'OIDC_AUTHORITY',
    defaultValue: 'https://auth.onlychris.net/application/o/pumplog/',
  );

  static const oidcClientId = String.fromEnvironment(
    'OIDC_CLIENT_ID',
    defaultValue: 'Se0ZrV0vLDMTrO2MTqS6iQk1Y7G1pvYaLpJMysRv',
  );

  // Standard auf die bestehende Web-Redirect-URI, damit der vorhandene Client passt.
  // Optional per --dart-define auf Custom Scheme überschreiben.
  static const oidcRedirectUrl = String.fromEnvironment(
    'OIDC_REDIRECT_URL',
    defaultValue: 'https://pumplog.onlychris.net/auth/callback',
  );

  static const oidcPostLogoutRedirectUrl = String.fromEnvironment(
    'OIDC_POST_LOGOUT_REDIRECT_URL',
    defaultValue: 'https://pumplog.onlychris.net/auth/logout',
  );
}
