import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_session.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';

final authServiceProvider = Provider((_) => AuthService());
final tokenStorageProvider = Provider((_) => TokenStorage());

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final storage = ref.read(tokenStorageProvider);
    final current = await storage.load();

    if (current?.refreshToken != null && _isExpired(current)) {
      final auth = ref.read(authServiceProvider);
      final refreshed = await auth.refresh(current!.refreshToken!);
      if (refreshed != null) {
        await storage.save(refreshed);
        return refreshed;
      }
      await storage.clear();
      return null;
    }

    return current;
  }

  bool _isExpired(AuthSession? session) {
    final exp = session?.expiresAt;
    if (exp == null) return false;
    return DateTime.now().isAfter(exp.subtract(const Duration(seconds: 30)));
  }

  Future<void> login() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authServiceProvider);
      final storage = ref.read(tokenStorageProvider);
      final session = await auth.login();
      if (session != null) {
        await storage.save(session);
      }
      return session;
    });
  }

  Future<void> logout() async {
    final auth = ref.read(authServiceProvider);
    final storage = ref.read(tokenStorageProvider);
    try {
      await auth.logout();
    } catch (_) {
      // ignore endSession errors (network/browser canceled)
    }
    await storage.clear();
    state = const AsyncData(null);
  }
}
