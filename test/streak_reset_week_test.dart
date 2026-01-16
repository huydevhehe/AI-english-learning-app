import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Streak Reset Week Logic Test', () {
    late FakeFirebaseFirestore fakeDb;

    setUp(() {
      fakeDb = FakeFirebaseFirestore();
    });

    test('CASE 1: Tuần mới phải GIỮ streakTotal, RESET checkedDays', () async {
      // 1️⃣ SETUP: Tạo data tuần cũ (7 ngày trước)
      final oldMonday = DateTime(2025, 12, 22); // Tuần trước
      final testUid = 'test_user_123';

      await fakeDb.collection('streaks').doc(testUid).set({
        'weekStart': Timestamp.fromDate(oldMonday),
        'checkedDays': [0, 1, 2, 3, 4, 5, 6], // Đã check 7 ngày
        'streakTotal': 7,
      });

      // 2️⃣ SIMULATE: Giả lập load() với ngày hiện tại (tuần mới)
      final now = DateTime(2025, 12, 29); // Tuần sau
      final newMonday = _mondayOf(now);

      final doc = await fakeDb.collection('streaks').doc(testUid).get();
      final data = doc.data()!;

      final fetchedWeekStart = (data['weekStart'] as Timestamp).toDate();
      final isNewWeek = _isNewWeek(now, fetchedWeekStart);

      print('📅 Old Monday: $oldMonday');
      print('📅 New Monday: $newMonday');
      print('🔄 Is New Week: $isNewWeek');

      // 3️⃣ ASSERT: Phải là tuần mới
      expect(isNewWeek, true);

      // 4️⃣ ACTION: Reset tuần mới (GIỮ streakTotal)
      if (isNewWeek) {
        await fakeDb.collection('streaks').doc(testUid).update({
          'weekStart': Timestamp.fromDate(newMonday),
          'checkedDays': [],
          'streakTotal': data['streakTotal'], // ✅ GIỮ NGUYÊN
        });
      }

      // 5️⃣ VERIFY: Kiểm tra kết quả
      final updatedDoc = await fakeDb.collection('streaks').doc(testUid).get();
      final updatedData = updatedDoc.data()!;

      print('✅ Updated checkedDays: ${updatedData['checkedDays']}');
      print('✅ Updated streakTotal: ${updatedData['streakTotal']}');

      expect(updatedData['checkedDays'], isEmpty); // ✅ Phải reset
      expect(updatedData['streakTotal'], 7); // ✅ Phải giữ nguyên
    });

    test('CASE 2: Cùng tuần thì KHÔNG reset', () async {
      // Setup: Tuần hiện tại
      final currentMonday = DateTime(2025, 12, 29);
      final testUid = 'test_user_456';

      await fakeDb.collection('streaks').doc(testUid).set({
        'weekStart': Timestamp.fromDate(currentMonday),
        'checkedDays': [0, 1, 2],
        'streakTotal': 3,
      });

      // Simulate: Load trong cùng tuần
      final now = DateTime(2025, 12, 31); // Thứ 4 cùng tuần

      final doc = await fakeDb.collection('streaks').doc(testUid).get();
      final data = doc.data()!;
      final fetchedWeekStart = (data['weekStart'] as Timestamp).toDate();
      final isNewWeek = _isNewWeek(now, fetchedWeekStart);

      // Verify: KHÔNG phải tuần mới
      expect(isNewWeek, false);
      expect(data['checkedDays'].length, 3); // Giữ nguyên
      expect(data['streakTotal'], 3); // Giữ nguyên
    });
  });
}

// =====================
// HELPER FUNCTIONS (copy từ code thật)
// =====================
DateTime _mondayOf(DateTime d) =>
    DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));

bool _isNewWeek(DateTime now, DateTime oldMonday) {
  return _mondayOf(now).isAfter(oldMonday);
}