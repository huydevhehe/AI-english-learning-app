import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/profile/presentation/pages/profile_page.dart';
import 'features/learning/learning_home/learning_home_page.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

// ⭐ streak
import 'features/streak/controllers/streak_controller.dart';
import 'features/streak/widgets/streak_checkin_dialog.dart';

import 'features/mini_game/mini_game_home/mini_game_screen.dart';
import 'features/chatbox/screen/chat_screen.dart';
import 'package:lottie/lottie.dart';
import 'features/exercises/projects_home/screens/projects_screen.dart';
import 'features/leaderboard/screens/leaderboard_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int index = 0;
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_dialogShown) return;

    final auth = context.read<AuthController>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    _dialogShown = true;

    final streak = context.read<StreakController>();
    streak.load(uid).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const StreakCheckinDialog(),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final uid = auth.user?.uid ?? "no-uid";

    final pages = [
      const LearningHomePage(), // 0
       const ProjectsScreen(), 
      const MiniGameScreen(), // 2
      ProfilePage(uid: uid), // 3
    ];

    return Stack(
      children: [
        Scaffold(
          body: pages[index],

          // ================= FOOTER =================
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              onTap: (i) {
  if (i == 2) {
    // 🔥 STREAK / LEADERBOARD
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LeaderboardScreen(),
      ),
    );
    return;
  }

  setState(() {
    if (i > 2) {
      index = i - 1;
    } else {
      index = i;
    }
  });
},

              items: [
                _navItem(
                  icon: Icons.menu_book_rounded,
                  label: "Học tập",
                  color: const Color(0xFF4CAF50), // xanh lá
                  active: index == 0,
                ),
                _navItem(
                  icon: Icons.assignment_rounded,
                  label: "Bài tập",
                  color: const Color(0xFFFF9800), // cam
                  active: index == 1,
                ),
                // ⭐ LEADERBOARD (FLAT - SAFE)
BottomNavigationBarItem(
  icon: Icon(
    Icons.local_fire_department_rounded, // 🔥 thay cúp
    size: 26,                            // nhỏ hơn
    color: const Color(0xFFFF9800),      // cam streak
  ),
  label: "Streak",
),

                _navItem(
                  icon: Icons.videogame_asset_rounded,
                  label: "Mini Game",
                  color: const Color(0xFF2196F3), // xanh dương
                  active: index == 2,
                ),
                _navItem(
                  icon: Icons.person_rounded,
                  label: "Hồ sơ",
                  color: const Color(0xFF9C27B0), // tím nhẹ
                  active: index == 3,
                ),
              ],
            ),
          ),
        ),

        // ================= CHAT BUTTON (LOTTIE) =================
        // ================= CHAT BUTTON (ROBOT ONLY) =================
        Positioned(
          right: 16,
          bottom: 90,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
            child: SizedBox(
              width: 72,
              height: 72,
              child: Transform.scale(
                scale: 1.2, // chỉnh robot to / nhỏ
                child: Lottie.asset(
                  'assets/animations/iconchatAI.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
          ),
        ),
        
      ],
    );
  }

  // ================= NAV ITEM BUILDER =================
  BottomNavigationBarItem _navItem({
    required IconData icon,
    required String label,
    required Color color,
    required bool active,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 24, color: active ? color : Colors.grey.shade400),
      label: label,
    );
  }
}


