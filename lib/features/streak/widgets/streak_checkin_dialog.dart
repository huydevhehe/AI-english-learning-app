import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../controllers/streak_controller.dart';
import 'streak_bar_7days.dart';

class StreakCheckinDialog extends StatelessWidget {
  const StreakCheckinDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<StreakController>();

    final showAnimation =
        streak.isCheckedToday || streak.justCheckedIn;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              streak.isCheckedToday
                  ? "Bạn đã điểm danh hôm nay 🎉"
                  : "Điểm danh hôm nay nhé 🔥",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 🎬 ANIMATION OK
            if (showAnimation) ...[
              SizedBox(
                height: 120,
                child: Lottie.asset(
                  'assets/animations/ok.json',
                  repeat: false,
                ),
              ),
              const SizedBox(height: 12),
            ],

            StreakBar7Days(isActive: streak.isDayActive),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: streak.isCheckedToday
                  ? () => Navigator.pop(context)
                  : () async {
                      await streak.checkIn();
                    },
              child: Text(
                streak.isCheckedToday ? "Đóng" : "Điểm danh",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
