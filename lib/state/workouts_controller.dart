import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/session_models.dart';
import '../services/pumplog_api.dart';
import 'auth_controller.dart';

final pumpLogApiProvider = Provider((_) => PumpLogApi());

final workoutsControllerProvider = AsyncNotifierProvider<WorkoutsController, List<SessionResponse>>(
  WorkoutsController.new,
);

class WorkoutsController extends AsyncNotifier<List<SessionResponse>> {
  @override
  Future<List<SessionResponse>> build() async {
    final auth = ref.watch(authControllerProvider).value;
    if (auth == null) return const [];
    return _load(auth.accessToken);
  }

  Future<List<SessionResponse>> _load(String token) async {
    final api = ref.read(pumpLogApiProvider);
    return api.getActiveSessions(token);
  }

  Future<void> refresh() async {
    final auth = ref.read(authControllerProvider).value;
    if (auth == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(auth.accessToken));
  }

  Future<void> addWorkout() async {
    final auth = ref.read(authControllerProvider).value;
    if (auth == null) return;
    final api = ref.read(pumpLogApiProvider);
    await api.createSession(auth.accessToken);
    await refresh();
  }
}
