import 'package:flutter/material.dart';
import '../models/leaderboard_user.dart';
import '../services/leaderboard_service.dart';

class LeaderboardController extends ChangeNotifier {
  final LeaderboardService _service = LeaderboardService();

  List<LeaderboardUser> users = [];
  bool loading = true;

  Future<void> load() async {
    loading = true;
    notifyListeners();

    users = await _service.fetchLeaderboard();

    loading = false;
    notifyListeners();
  }

  List<LeaderboardUser> get top3 =>
      users.take(3).toList();

  List<LeaderboardUser> get rest =>
      users.length > 3 ? users.sublist(3, users.length.clamp(3, 10)) : [];
}
