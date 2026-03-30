import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/auth_controller.dart';
import '../../state/workouts_controller.dart';
import '../widgets/session_card.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B10),
        title: const Text('PumpLog Workouts'),
        actions: [
          IconButton(
            onPressed: () => ref.read(workoutsControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF101018), Color(0xFF050508)],
          ),
        ),
        child: workouts.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Text('Noch keine Workouts geplant.', style: TextStyle(color: Colors.white60)),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ref.read(workoutsControllerProvider.notifier).refresh(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                itemBuilder: (_, i) => SessionCard(session: items[i]),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: items.length,
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Fehler beim Laden:\n$e',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[300],
        foregroundColor: Colors.black,
        onPressed: () => ref.read(workoutsControllerProvider.notifier).addWorkout(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
