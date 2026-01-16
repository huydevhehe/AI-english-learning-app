import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../auth/presentation/pages/login_page.dart';
import '../../../../../core/theme/theme_controller.dart';
import './profile_edit_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ================================
  //      STATE LOCAL (v1.0)
  // ================================
  bool soundEffects = true;
  bool vibration = true;

  String currentLanguage = "Tiếng Việt"; // v1.0 chỉ hỗ trợ tiếng Việt

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ============================
          //      TÀI KHOẢN
          // ============================
          const Text(
            "TÀI KHOẢN",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),

         _item(
  icon: Icons.person,
  text: "Sửa hồ sơ",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileEditPage()),
    );
  },
),


          // ❌ ẨN v1.0 – chưa có xử lý riêng tư thật
          // _item(icon: Icons.privacy_tip, text: "Riêng tư", onTap: () {}),

          const SizedBox(height: 25),

          // ============================
          //         TÙY CHỌN
          // ============================
          const Text(
            "TÙY CHỌN",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),

          // ❌ ẨN v1.0 – chưa có notification thật
          // SwitchListTile(
          //   value: notifications,
          //   onChanged: (v) => setState(() => notifications = v),
          //   title: const Text("Thông báo"),
          //   secondary: const Icon(Icons.notifications),
          // ),

          // ✅ GIỮ: Hiệu ứng âm thanh
          // SwitchListTile(
          //   value: soundEffects,
          //   onChanged: (v) => setState(() => soundEffects = v),
          //   title: const Text("Hiệu ứng âm thanh"),
          //   secondary: const Icon(Icons.volume_up),
          // ),

          // ✅ GIỮ: Rung phản hồi
          // SwitchListTile(
          //   value: vibration,
          //   onChanged: (v) => setState(() => vibration = v),
          //   title: const Text("Rung phản hồi"),
          //   secondary: const Icon(Icons.vibration),
          // ),

          // ✅ GIỮ: Chế độ tối (đã có ThemeController)
          // ============================
//        GIAO DIỆN (THEME)
// ============================
Consumer<ThemeController>(
  builder: (context, theme, _) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Giao diện",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // ===== AUTO THEO GIỜ =====
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Tự động theo giờ"),
              subtitle: Text(
                "Tối từ ${theme.darkStartHour}:00 → ${theme.darkEndHour}:00",
              ),
              value: theme.mode == ThemeModeType.schedule,
              onChanged: (v) {
                if (v) {
                  theme.setSchedule(
                    startHour: theme.darkStartHour,
                    endHour: theme.darkEndHour,
                  );
                } else {
                  theme.setManual(theme.isDarkManual);
                }
              },
              secondary: const Icon(Icons.schedule),
            ),

            // ===== DARK MODE THỦ CÔNG =====
            if (theme.mode == ThemeModeType.manual)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Dark mode"),
                value: theme.isDarkManual,
                onChanged: theme.setManual,
                secondary: const Icon(Icons.dark_mode),
              ),

            // ===== CHỌN GIỜ (AUTO MODE) =====
            if (theme.mode == ThemeModeType.schedule) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: const Text("Giờ bắt đầu"),
                      onPressed: () async {
                        final h = await showDialog<int>(
                          context: context,
                          builder: (_) => _hourDialog(
                            context,
                            "Giờ bắt đầu",
                            theme.darkStartHour,
                          ),
                        );
                        if (h != null) {
                          theme.setSchedule(
                            startHour: h,
                            endHour: theme.darkEndHour,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      child: const Text("Giờ kết thúc"),
                      onPressed: () async {
                        final h = await showDialog<int>(
                          context: context,
                          builder: (_) => _hourDialog(
                            context,
                            "Giờ kết thúc",
                            theme.darkEndHour,
                          ),
                        );
                        if (h != null) {
                          theme.setSchedule(
                            startHour: theme.darkStartHour,
                            endHour: h,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  },
),



          const SizedBox(height: 25),

          // ============================
          //      HỌC TẬP
          // ============================
          const Text(
            "HỌC TẬP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),

          // ✅ GIỮ: Ngôn ngữ (v1.0 chỉ dialog)
          _item(
            icon: Icons.language,
            text: "Ngôn ngữ ($currentLanguage)",
            onTap: () => _showLanguageDialog(),
          ),

          const SizedBox(height: 25),

          // ============================
          //      HỖ TRỢ
          // ============================
          const Text(
            "HỖ TRỢ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),

          // ✅ GIỮ: Trung tâm trợ giúp (dialog email)
          _item(
            icon: Icons.help_center,
            text: "Trung tâm trợ giúp",
            onTap: () => _showHelpDialog(),
          ),

          const SizedBox(height: 40),

          
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Đăng xuất",
                style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final auth = context.read<AuthController>();
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ================================
  //      DIALOG: SỬA HỒ SƠ (v1.0)
  // ================================
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sửa hồ sơ"),
        content: const Text(
          "Phiên bản hiện tại cho phép chỉnh sửa thông tin cơ bản.\n"
          "Các tính năng nâng cao sẽ được cập nhật sau.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ================================
  //      DIALOG: NGÔN NGỮ (v1.0)
  // ================================
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ngôn ngữ"),
        content: const Text(
          "Phiên bản hiện tại chỉ hỗ trợ Tiếng Việt.\n"
          "Các ngôn ngữ khác sẽ được cập nhật sau.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ================================
  //      DIALOG: TRỢ GIÚP
  // ================================
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Trung tâm trợ giúp"),
        content: const Text(
          "Nếu bạn gặp vấn đề khi sử dụng ứng dụng,\n"
          "vui lòng liên hệ:\n\n"
          "📧 nguyenquochuyc7@gmail.com",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  // ================================
  //      ITEM COMPONENT
  // ================================
  Widget _item({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
Widget _hourDialog(BuildContext context, String title, int current) {
  return AlertDialog(
    title: Text(title),
    content: SizedBox(
      width: double.maxFinite,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 24,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (_, i) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                i == current ? Colors.deepPurple : null,
          ),
          onPressed: () => Navigator.pop(context, i),
          child: Text("$i h"),
        ),
      ),
    ),
  );
}
