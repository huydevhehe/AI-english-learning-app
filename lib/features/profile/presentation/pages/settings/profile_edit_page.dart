import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../auth/presentation/pages/login_page.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  bool loading = true;
  bool showPassword = false;
  bool saving = false;

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      _nameCtrl.text = doc['fullName'] ?? '';
    }

    setState(() => loading = false);
  }

  String get avatarChar =>
      _nameCtrl.text.isEmpty ? 'U' : _nameCtrl.text[0].toUpperCase();

  // =========================
  // SAVE PROFILE + CHANGE PASSWORD
  // =========================
  Future<void> _save() async {
    if (user == null || user!.email == null) return;

    final name = _nameCtrl.text.trim();
    final oldPass = _oldPassCtrl.text.trim();
    final newPass = _newPassCtrl.text.trim();

    if (name.isEmpty) {
      _msg("Tên không được để trống");
      return;
    }

    // ===== ĐỔI MẬT KHẨU (BẮT BUỘC CẢ 2 Ô) =====
    if (oldPass.isEmpty || newPass.isEmpty) {
      _msg("Vui lòng nhập đầy đủ mật khẩu hiện tại và mật khẩu mới");
      return;
    }

    if (newPass.length < 6) {
      _msg("Mật khẩu mới phải có ít nhất 6 ký tự");
      return;
    }

    setState(() => saving = true);

    try {
      // 1. Re-authenticate bằng mật khẩu cũ
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPass,
      );
      await user!.reauthenticateWithCredential(credential);

      // 2. Update mật khẩu mới
      await user!.updatePassword(newPass);

      // 3. Update tên (Firestore)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'fullName': name});

      // 4. Logout bắt buộc
      await FirebaseAuth.instance.signOut();

      _msg("Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _msg("Mật khẩu hiện tại không đúng");
      } else if (e.code == 'requires-recent-login') {
        _msg("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại");
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        _msg("Không thể đổi mật khẩu, vui lòng thử lại");
      }
    }

    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===== AVATAR + EMAIL =====
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.blueGrey,
              child: Text(
                avatarChar,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? '',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            _label("Tên"),
            _input(_nameCtrl),

            const SizedBox(height: 20),

            _label("Mật khẩu hiện tại"),
            _passwordInput(_oldPassCtrl),

            const SizedBox(height: 12),

            _label("Mật khẩu mới"),
            _passwordInput(_newPassCtrl),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : _save,
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("LƯU & ĐỔI MẬT KHẨU"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // UI HELPERS
  // =========================
  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _input(TextEditingController ctrl) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        filled: true,
      fillColor: isDark
          ? const Color(0xFF1E1E1E) // nền tối dịu
          : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordInput(TextEditingController ctrl) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: ctrl,
      obscureText: !showPassword,
      decoration: InputDecoration(
        filled: true,
          fillColor: isDark
          ? const Color(0xFF1E1E1E)
          : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
      ),
    );
  }

  void _msg(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
