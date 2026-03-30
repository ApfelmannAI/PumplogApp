import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../core/app_config.dart';
import '../models/auth_session.dart';

class AuthService {
  final FlutterAppAuth _appAuth;

  AuthService([FlutterAppAuth? appAuth]) : _appAuth = appAuth ?? const FlutterAppAuth();

  Future<AuthSession?> login() async {
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        AppConfig.oidcClientId,
        AppConfig.oidcRedirectUrl,
        issuer: AppConfig.oidcAuthority,
        scopes: const ['openid', 'profile', 'email', 'offline_access'],
      ),
    );

    if (result?.accessToken == null) return null;

    DateTime? expiresAt;
    final token = result!.accessToken!;
    if (JwtDecoder.isExpired(token) == false) {
      final exp = JwtDecoder.getExpirationDate(token);
      expiresAt = exp;
    }

    return AuthSession(
      accessToken: token,
      refreshToken: result.refreshToken,
      expiresAt: expiresAt,
    );
  }

  Future<AuthSession?> refresh(String refreshToken) async {
    final result = await _appAuth.token(
      TokenRequest(
        AppConfig.oidcClientId,
        AppConfig.oidcRedirectUrl,
        issuer: AppConfig.oidcAuthority,
        refreshToken: refreshToken,
        scopes: const ['openid', 'profile', 'email', 'offline_access'],
      ),
    );

    if (result?.accessToken == null) return null;

    return AuthSession(
      accessToken: result!.accessToken!,
      refreshToken: result.refreshToken ?? refreshToken,
      expiresAt: result.accessTokenExpirationDateTime,
    );
  }

  Future<void> logout() async {
    await _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: null,
        postLogoutRedirectUrl: AppConfig.oidcPostLogoutRedirectUrl,
        issuer: AppConfig.oidcAuthority,
      ),
    );
  }
}
