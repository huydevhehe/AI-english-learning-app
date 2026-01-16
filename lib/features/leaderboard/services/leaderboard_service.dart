import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leaderboard_user.dart';

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<LeaderboardUser>> fetchLeaderboard() async {
    final streakSnap = await _db.collection('streaks').get();
    final userSnap = await _db.collection('users').get();

    final userMap = {
      for (var d in userSnap.docs) d.id: d.data(),
    };

    final List<LeaderboardUser> result = [];

    for (final doc in streakSnap.docs) {
      final uid = doc.id;
      final streak = (doc.data()['streakTotal'] ?? 0) as int;

      final user = userMap[uid];
      if (user == null) continue;

      result.add(
        LeaderboardUser(
          uid: uid,
          name: user['fullName'] ?? 'Unknown',
          streak: streak,
          createdAt:
              (user['createdAt'] as Timestamp).toDate(),
        ),
      );
    }

    // SORT LOGIC
    result.sort((a, b) {
      if (b.streak != a.streak) {
        return b.streak.compareTo(a.streak);
      }
      return a.createdAt.compareTo(b.createdAt);
    });

    return result;
  }
}
