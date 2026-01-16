import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/streak_model.dart';

class StreakService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  StreakService(this.uid);

  DocumentReference<Map<String, dynamic>> get _ref =>
      _db.collection('streaks').doc(uid);

  // =====================
  // FETCH
  // =====================
  Future<StreakModel?> fetch() async {
    final snap = await _ref.get();
    if (!snap.exists) return null;
    return StreakModel.fromMap(snap.data());
  }

  // =====================
  // CHECK FIREBASE (SOURCE OF TRUTH)
  // =====================
  Future<bool> hasCheckedToday(
    DateTime weekStart,
    int todayIndex,
  ) async {
    final snap = await _ref.get();
    if (!snap.exists) return false;

    final data = snap.data()!;
    final checkedDays = List<int>.from(data['checkedDays'] ?? []);

    return checkedDays.contains(todayIndex);
  }

  // =====================
  // CHECK-IN (TRANSACTION – CHỐNG BUG 100%)
  // =====================
  Future<bool> checkIn({
    required DateTime weekStart,
    required int todayIndex,
  }) async {
    return _db.runTransaction<bool>((tx) async {
      final snap = await tx.get(_ref);

      // chưa có document → tạo mới
      if (!snap.exists) {
        final model = StreakModel(
          weekStart: weekStart,
          checkedDays: [todayIndex],
          streakTotal: 1,
        );

        tx.set(_ref, model.toMap());
        return true;
      }

      final data = snap.data()!;
      final checkedDays = List<int>.from(data['checkedDays'] ?? []);

      // 🔒 ĐÃ CHECK → CHẶN
      if (checkedDays.contains(todayIndex)) {
        return false;
      }

      checkedDays.add(todayIndex);

      tx.update(_ref, {
        'checkedDays': checkedDays,
        'streakTotal': (data['streakTotal'] ?? 0) + 1,
      });

      return true;
    });
  }
  // =====================
// RESET WEEK (GIỮ STREAK TOTAL)
// =====================
Future<void> resetWeek(DateTime newMonday, int keepTotal) async {
  await _db.collection('streaks').doc(uid).update({  // ✅ Dùng _db thay vì _ref
    'weekStart': Timestamp.fromDate(newMonday),
    'checkedDays': [],
    'streakTotal': keepTotal,
  });
}
}
