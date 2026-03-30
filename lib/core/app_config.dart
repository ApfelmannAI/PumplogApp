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

  // Mobile redirect scheme (muss in Android/iOS passend registriert werden)
  static const oidcRedirectUrl = String.fromEnvironment(
    'OIDC_REDIRECT_URL',
    defaultValue: 'com.apfelmannai.pumplog:/oauthredirect',
  );

  static const oidcPostLogoutRedirectUrl = String.fromEnvironment(
    'OIDC_POST_LOGOUT_REDIRECT_URL',
    defaultValue: 'com.apfelmannai.pumplog:/logout',
  );
}
