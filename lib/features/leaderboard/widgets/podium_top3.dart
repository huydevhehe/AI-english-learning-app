import 'package:flutter/material.dart';
import '../models/leaderboard_user.dart';

class PodiumTop3 extends StatelessWidget {
  final List<LeaderboardUser> users;

  const PodiumTop3({super.key, required this.users});

  Color _color(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFC107); // vàng
      case 2:
        return const Color(0xFFB0BEC5); // bạc
      case 3:
        return const Color(0xFFCD7F32); // đồng
      default:
        return Colors.grey;
    }
  }

  IconData _icon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.star;
      case 3:
        return Icons.military_tech;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(users.length, (i) {
        final u = users[i];
        final rank = i + 1;

        return Column(
          children: [
            Icon(_icon(rank), size: 36, color: _color(rank)),
            const SizedBox(height: 6),
            Text(
              u.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "🔥 ${u.streak}",
              style: TextStyle(color: _color(rank)),
            ),
            const SizedBox(height: 8),
            Container(
              width: 70,
              height: rank == 1 ? 100 : 80,
              decoration: BoxDecoration(
                color: _color(rank),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        );
      }),
    );
  }
}
