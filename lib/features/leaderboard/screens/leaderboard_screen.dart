import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/leaderboard_controller.dart';
import '../widgets/podium_top3.dart';
import '../widgets/leaderboard_tile.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaderboardController()..load(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<LeaderboardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 Bảng xếp hạng"),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: c.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PodiumTop3(users: c.top3),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: c.rest.length,
                      itemBuilder: (_, i) {
                        final user = c.rest[i];
                        return LeaderboardTile(
                          rank: i + 4,
                          user: user,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
