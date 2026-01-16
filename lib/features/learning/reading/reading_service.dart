import 'package:cloud_firestore/cloud_firestore.dart';
import 'reading_model.dart';

class ReadingService {
  final _db = FirebaseFirestore.instance;

  /// Lấy toàn bộ bài đọc
  Future<List<ReadingPassage>> getAllPassages() async {
    final snap = await _db.collection('reading_passages').get();

    return snap.docs.map((doc) {
      final data = doc.data();

      return ReadingPassage.fromMap(
        data,
        doc.id,
      );
    }).toList();
  }

  /// Lấy ngẫu nhiên 1 bài
  Future<ReadingPassage?> getRandomPassage() async {
    final list = await getAllPassages();
    if (list.isEmpty) return null;

    list.shuffle();
    return list.first;
  }
}
