import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../streak/controllers/streak_controller.dart';
import '../state/profile_notifier.dart';
import 'settings/settings_page.dart';
import '../../../streak/widgets/streak_bar_7days.dart';

class ProfilePage extends StatelessWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = context.watch<ProfileNotifier>().state;
    final profile = profileState.profile;

    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final avatarUrl = profile.avatarUrl ?? "";
    final displayChar =
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : "?";

    final user = FirebaseAuth.instance.currentUser;
    final createdAt = user?.metadata.creationTime;
    final joinedText = createdAt != null
        ? "Tham gia từ ${createdAt.month}/${createdAt.year}"
        : "";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Hồ sơ cá nhân"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          children: [
            // =================================================
            // 🌈 HERO PROFILE CARD
            // =================================================
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
  colors: [
    Color(0xFF2563EB), // Blue 600
    Color(0xFF3B82F6), // Blue 500
  ],
),


                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // AVATAR
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                        child: avatarUrl.isEmpty
                            ? Text(
                                displayChar,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // NAME
                    Text(
                      profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // EMAIL
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),

                    if (joinedText.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            joinedText,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // =================================================
            // 🔥 STREAK CARD
            // =================================================
            Consumer<StreakController>(
              builder: (context, streak, _) {
                final total = streak.model?.streakTotal ?? 0;

                return _SectionCard(
                  title: "Chuỗi học tập",
                  icon: Icons.local_fire_department_rounded,
                  iconColor: Colors.orange,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$total ngày liên tiếp",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Hãy duy trì thói quen học mỗi ngày",
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 18),
                      StreakBar7Days(
                        isActive: streak.isDayActive,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // =================================================
            // 📊 QUICK STATS (ĐỂ APP CÓ CHIỀU SÂU)
            // =================================================
            Row(
              children: const [
                Expanded(
                  child: _MiniStatCard(
                    icon: Icons.menu_book_rounded,
                    label: "Bài học",
                    value: "Có nhiều ",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    icon: Icons.psychology_alt_rounded,
                    label: "AI Thông Minh",
                    value: "Tích hợp",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// 🔹 SECTION CARD
// =================================================
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.12),
        ),
        boxShadow: theme.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// =================================================
// 🔹 MINI STAT CARD
// =================================================
class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
