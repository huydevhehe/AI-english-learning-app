import 'package:flutter/material.dart';
import '../models/streak_model.dart';
import '../services/streak_service.dart';

class StreakController extends ChangeNotifier {
  StreakService? _service;
  StreakModel? _model;

  bool _justCheckedIn = false;

  StreakModel? get model => _model;
  bool get justCheckedIn => _justCheckedIn;

  // =====================
  // UTILS
  // =====================
  DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day)
          .subtract(Duration(days: d.weekday - 1));

  bool _isNewWeek(DateTime now, DateTime oldMonday) {
    return _mondayOf(now).isAfter(oldMonday);
  }

  int get todayIndex {
    if (_model == null) return DateTime.now().weekday - 1;
    final diff = DateTime.now().difference(_model!.weekStart).inDays;
    return diff.clamp(0, 6);
  }

  // =====================
  // LOAD (SOURCE = FIREBASE)
  // =====================
  Future<void> load(String uid) async {
    _service ??= StreakService(uid);

    final fetched = await _service!.fetch();
    final now = DateTime.now();

    if (fetched == null) {
    _model = StreakModel.initial();
  } else if (_isNewWeek(now, fetched.weekStart)) {
    // ✅ Reset tuần mới nhưng GIỮ streakTotal
    await _service!.resetWeek(_mondayOf(now), fetched.streakTotal);
    _model = await _service!.fetch(); // Reload từ Firebase
  } else {
    _model = fetched;
  }

    _justCheckedIn = false;
    notifyListeners();
  }

  // =====================
  // GETTERS UI
  // =====================
  bool get isCheckedToday =>
      _model?.checkedDays.contains(todayIndex) ?? false;

  bool isDayActive(int index) =>
      _model?.checkedDays.contains(index) ?? false;

  // =====================
  // CHECK-IN (HỎI FIREBASE)
  // =====================
  Future<void> checkIn() async {
    if (_model == null || _service == null) return;

    final success = await _service!.checkIn(
      weekStart: _model!.weekStart,
      todayIndex: todayIndex,
    );

    if (!success) {
      // Firebase nói: đã check rồi
      _justCheckedIn = false;
      notifyListeners();
      return;
    }

    // Reload lại từ Firebase để đồng bộ tuyệt đối
    _model = await _service!.fetch();
    _justCheckedIn = true;
    notifyListeners();
  }
}
