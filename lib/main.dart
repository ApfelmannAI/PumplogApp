import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/screens/login_screen.dart';
import 'ui/screens/workouts_screen.dart';
import 'state/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PumpLogApp()));
}

class PumpLogApp extends ConsumerWidget {
  const PumpLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      title: 'PumpLog',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0B10),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFB74D),
          secondary: Color(0xFFFF9800),
        ),
      ),
      home: authState.maybeWhen(
        data: (session) => session == null ? const LoginScreen() : const WorkoutsScreen(),
        orElse: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
