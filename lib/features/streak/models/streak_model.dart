import 'package:cloud_firestore/cloud_firestore.dart';

class StreakModel {
  final DateTime weekStart; // LUÔN là thứ 2
  final List<int> checkedDays; // 0..6 (T2..CN)
  final int streakTotal;

  StreakModel({
    required this.weekStart,
    required this.checkedDays,
    required this.streakTotal,
  });

  // ======================
  // UTILS
  // ======================
  static DateTime mondayOf(DateTime d) {
    final onlyDate = DateTime(d.year, d.month, d.day);
    return onlyDate.subtract(Duration(days: onlyDate.weekday - 1));
  }

  // ======================
  // INITIAL (BẮT BUỘC)
  // ======================
  factory StreakModel.initial() {
    final now = DateTime.now();
    return StreakModel(
      weekStart: mondayOf(now), // ✅ KHÔNG BAO GIỜ dùng DateTime.now() trực tiếp
      checkedDays: [],
      streakTotal: 0,
    );
  }

  // ======================
  // FIREBASE
  // ======================
  factory StreakModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return StreakModel.initial();
    }

    final rawWeekStart = map['weekStart'];

    return StreakModel(
      weekStart: rawWeekStart is Timestamp
          ? mondayOf(rawWeekStart.toDate())
          : StreakModel.initial().weekStart,
      checkedDays: List<int>.from(map['checkedDays'] ?? []),
      streakTotal: map['streakTotal'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weekStart': Timestamp.fromDate(weekStart),
      'checkedDays': checkedDays,
      'streakTotal': streakTotal,
    };
  }
}
