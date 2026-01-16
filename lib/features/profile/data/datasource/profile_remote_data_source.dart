import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSource({
    required this.firestore,
    required this.storage,
  });

  Future<ProfileModel> getProfile(String uid) async {
    final docRef = firestore.collection("users").doc(uid);
    final doc = await docRef.get();

    // Auto-create nếu chưa có
    if (!doc.exists) {
      final defaultProfile = ProfileModel(
        uid: uid,
        name: "Người dùng mới",
        email: "",
        avatarUrl: "",
        username: "",
      );

      await docRef.set(defaultProfile.toMap());
      return defaultProfile;
    }

    return ProfileModel.fromMap(doc.data()!);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await firestore
        .collection("users")
        .doc(profile.uid)
        .update(profile.toMap());
  }

  Future<String> uploadAvatar(String uid, String filePath) async {
  final file = File(filePath);

  if (!file.existsSync()) {
    throw Exception("File không tồn tại: $filePath");
  }

  final ref = storage.ref().child("avatars/$uid/avatar.jpg");

  final uploadTask = await ref.putFile(file);

  final url = await uploadTask.ref.getDownloadURL();

  return url;
}

}
