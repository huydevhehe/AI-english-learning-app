import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required String uid,
    required String name,
    required String email,
    String? avatarUrl,
    String? username,
  }) : super(
          uid: uid,
          name: name,
          email: email,
          avatarUrl: avatarUrl,
          username: username,
        );
factory ProfileModel.fromMap(Map<String, dynamic> map) {
  return ProfileModel(
    uid: map["uid"] ?? "",
    name: map["fullName"] ?? "",  // Sửa tại đây
    email: map["email"] ?? "",
    avatarUrl: map["avatarUrl"],
    username: map["username"],
  );
}


Map<String, dynamic> toMap() {
  return {
    "uid": uid,
    "fullName": name,   // Đổi "name" → "fullName"
    "email": email,
    "avatarUrl": avatarUrl,
    "username": username,
  };
}

}
