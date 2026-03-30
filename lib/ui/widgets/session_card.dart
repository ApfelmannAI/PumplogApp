import 'package:flutter/material.dart';

import '../../models/session_models.dart';

class SessionCard extends StatelessWidget {
  final SessionResponse session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF15151C),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        collapsedIconColor: Colors.white70,
        iconColor: Colors.orangeAccent,
        title: Text(
          session.title.isEmpty ? 'Workout #${session.sessionNumber}' : session.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${session.sections.length} Übungen · ${session.isActive ? 'aktiv' : 'inaktiv'}',
          style: const TextStyle(color: Colors.white60),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (session.sections.isEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Noch keine Übungen', style: TextStyle(color: Colors.white54)),
            )
          else
            ...session.sections.map(
              (s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.orangeAccent, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.sectionType,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
