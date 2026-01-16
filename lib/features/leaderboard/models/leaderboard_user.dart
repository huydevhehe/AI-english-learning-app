class LeaderboardUser {
  final String uid;
  final String name;
  final int streak;
  final DateTime createdAt;

  LeaderboardUser({
    required this.uid,
    required this.name,
    required this.streak,
    required this.createdAt,
  });
}
