import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng ký tài khoản
  Future<User?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      // Tạo user auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = credential.user!.uid;

      // Tạo profile mặc định trong Firestore
      await _firestore.collection("users").doc(uid).set({
        "fullName": fullName.trim(),
        "email": email.trim(),
        "avatarUrl": "",
        "goal": "",
        "level": "",
        "createdAt": FieldValue.serverTimestamp(),
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Đăng ký thất bại";
    }
  }

  // Đăng nhập
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Sai tài khoản hoặc mật khẩu";
    }
  }

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Đăng xuất
  Future<void> logout() async => await _auth.signOut();
}
