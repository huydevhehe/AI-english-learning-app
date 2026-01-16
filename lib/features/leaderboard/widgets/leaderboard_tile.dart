import 'package:flutter/material.dart';
import '../models/leaderboard_user.dart';

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final LeaderboardUser user;
  final bool highlight;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.user,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? Colors.green : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Text(
            "$rank",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text("🔥 ${user.streak}"),
        ],
      ),
    );
  }
}
