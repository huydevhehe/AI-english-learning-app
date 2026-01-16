class ProfileEntity {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? username;

  ProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.username,
  });

  ProfileEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    String? username,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      username: username ?? this.username,
    );
  }
}
