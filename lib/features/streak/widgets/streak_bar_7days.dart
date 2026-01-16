import 'package:flutter/material.dart';

class StreakBar7Days extends StatelessWidget {
  final bool Function(int) isActive;

  const StreakBar7Days({super.key, required this.isActive});

  static const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = isActive(i);
          return Container(
            width: 46,
            decoration: BoxDecoration(
              color: active ? Colors.deepOrange : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department,
                    color: active ? Colors.white : Colors.grey),
                Text(days[i],
                    style: TextStyle(
                        color: active ? Colors.white : Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
