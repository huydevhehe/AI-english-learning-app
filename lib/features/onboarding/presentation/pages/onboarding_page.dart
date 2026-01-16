import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../app_root.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideUp;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasSeenOnboard", true);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFE3F2FD),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                // 🎬 LOTTIE (fade + scale)
                FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.92, end: 1).animate(_fade),
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Lottie.asset(
                        'assets/animations/onboard.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🐻 TITLE
                SlideTransition(
                  position: _slideUp,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Text(
                      "Chào mừng bạn đến với BearGo!",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF263238),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ✨ SUBTITLE
                SlideTransition(
                  position: _slideUp,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Text(
                      "Học tiếng Anh mỗi ngày theo cách\nnhẹ nhàng – vui vẻ – hiệu quả.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 🌈 FEATURES
                SlideTransition(
                  position: _slideUp,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Column(
                      children: const [
                        _FeatureItem(
                          icon: Icons.local_fire_department,
                          color: Color(0xFFFF7043),
                          text: "Giữ streak học mỗi ngày",
                        ),
                        SizedBox(height: 14),
                        _FeatureItem(
                          icon: Icons.videogame_asset_rounded,
                          color: Color(0xFF42A5F5),
                          text: "Học qua mini game vui nhộn",
                        ),
                        SizedBox(height: 14),
                        _FeatureItem(
                          icon: Icons.chat_bubble_rounded,
                          color: Color(0xFF66BB6A),
                          text: "Luyện nói cùng AI thông minh",
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // 🚀 BUTTON (delay nhẹ)
                SlideTransition(
                  position: _slideUp,
                  child: FadeTransition(
                    opacity: _fade,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7043),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          final auth = context.read<AuthController>();
                          if (auth.user == null) return;

                          await _completeOnboarding();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppRoot(),
                            ),
                          );
                        },
                        child: const Text(
                          "Bắt đầu ngay 🚀",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================
// FEATURE ITEM
// =======================
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
