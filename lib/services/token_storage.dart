import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_session.dart';

class TokenStorage {
  static const _keyAccess = 'pumplog_access_token';
  static const _keyRefresh = 'pumplog_refresh_token';
  static const _keyExpires = 'pumplog_expires_at';

  final FlutterSecureStorage _storage;

  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<AuthSession?> load() async {
    final access = await _storage.read(key: _keyAccess);
    if (access == null || access.isEmpty) return null;

    final refresh = await _storage.read(key: _keyRefresh);
    final expiresRaw = await _storage.read(key: _keyExpires);

    return AuthSession(
      accessToken: access,
      refreshToken: refresh,
      expiresAt: expiresRaw == null ? null : DateTime.tryParse(expiresRaw),
    );
  }

  Future<void> save(AuthSession session) async {
    await _storage.write(key: _keyAccess, value: session.accessToken);
    await _storage.write(key: _keyRefresh, value: session.refreshToken);
    await _storage.write(key: _keyExpires, value: session.expiresAt?.toIso8601String());
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
    await _storage.delete(key: _keyExpires);
  }
}
