import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;       // giữ nguyên – UI đang dùng
  User? user;                   // giữ nguyên – UI đang dùng

  // -----------------------------
  // ĐĂNG KÝ
  // -----------------------------
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required Function(String) onError,
    required Function() onSuccess,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. Tạo user Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credential.user;

      if (user == null) {
        onError("Không tạo được tài khoản.");
        return;
      }

      // 2. Tạo hồ sơ mặc định Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set({
             "uid": user!.uid, 
        "fullName": fullName.isNotEmpty ? fullName : "Người dùng mới",
        "email": email,
        "avatarUrl": "",
        "createdAt": FieldValue.serverTimestamp(),
      });

        onSuccess();

} on FirebaseAuthException catch (e) {
  onError(_firebaseError(e));

} catch (e) {
  // ✅ CÁI NÀY ĐỂ CUỐI
  onError('Lỗi không xác định');

} finally {
  isLoading = false;
  notifyListeners();
}
  }

  // -----------------------------
  // ĐĂNG NHẬP
  // -----------------------------
  Future<void> login({
    required String email,
    required String password,
    required Function(String) onError,
    required Function() onSuccess,
  }) async {
      debugPrint('[AUTH] login start | email=$email');
    try {
      isLoading = true;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credential.user;

      if (user == null) {
        onError("Không đăng nhập được.");
        return;
      }
    debugPrint('[AUTH] login SUCCESS');
      onSuccess();
    } on FirebaseAuthException catch (e) {
       debugPrint('[AUTH] login ERROR | code=${e.code}');
      onError(_firebaseError(e));
    } catch (e) {
       debugPrint('[AUTH] login UNKNOWN ERROR | $e');
      onError(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
       debugPrint('[AUTH] login END');
    }
  }

  // -----------------------------
  // ĐĂNG XUẤT
  // -----------------------------
  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  // -----------------------------
  // LỖI FIREBASE
  // -----------------------------
  String _firebaseError(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Email không hợp lệ';
    case 'email-already-in-use':
      return 'Email đã được sử dụng';
    case 'weak-password':
      return 'Mật khẩu quá yếu';
    case 'user-not-found':
      return 'Tài khoản không tồn tại';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email hoặc mật khẩu không đúng';
    case 'user-disabled':
      return 'Tài khoản đã bị khóa';
    default:
      return 'Đăng nhập thất bại, vui lòng thử lại';
  }
}

}
