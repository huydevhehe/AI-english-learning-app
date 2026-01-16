import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_word_model.dart';

class MatchWordService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách từ vựng ngẫu nhiên từ TẤT CẢ các chủ đề trên Firebase
  Future<List<MatchWordPair>> getRandomWords(int count) async {
    try {
      List<Map<String, dynamic>> allWords = [];

      // 1. Lấy tất cả documents trong collection 'miniGameWords'
      final querySnapshot = await _db.collection('miniGameWords').get();

      if (querySnapshot.docs.isEmpty) {
        // Nếu chưa có dữ liệu trên Firebase, trả về list rỗng hoặc seed data dự phòng (nếu muốn)
        return [];
      }

      // 2. Duyệt qua từng doc và gộp mảng 'words'
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        if (data.containsKey('words') && data['words'] is List) {
          final List<dynamic> wordsList = data['words'];
          for (var wordItem in wordsList) {
            if (wordItem is Map<String, dynamic>) {
              allWords.add(wordItem);
            }
          }
        }
      }

      // 3. Chuyển đổi sang Model
      List<MatchWordPair> pairs = allWords.map((e) => MatchWordPair.fromMap(e)).toList();

      // 4. Xáo trộn và lấy số lượng cần thiết
      pairs.shuffle(Random());
      
      if (pairs.length > count) {
        return pairs.sublist(0, count);
      }
      return pairs;
    } catch (e) {
      print("Error fetching match word data: $e");
      return [];
    }
  }
}
