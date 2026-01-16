import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/memory_card_model.dart';

class MemoryCardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<MemoryCardItem>> getGameCards(int pairCount) async {
    try {
      List<Map<String, dynamic>> allWords = [];

      // 1. Lấy tất cả documents từ Firebase
      final querySnapshot = await _db.collection('miniGameWords').get();

      if (querySnapshot.docs.isEmpty) {
         return [];
      }

      // 2. Gộp mảng 'words' từ tất cả các chủ đề
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

      // 3. Lấy ngẫu nhiên số lượng cặp từ cần thiết
      allWords.shuffle(Random());
      if (allWords.length > pairCount) {
        allWords = allWords.sublist(0, pairCount);
      }

      // 4. Tạo thẻ bài
      List<MemoryCardItem> cards = [];
      final random = Random();

      for (var word in allWords) {
        final String id = word['en']!; // Dùng tiếng Anh làm ID chung cho cặp
        
        // --- Thẻ 1: Tiếng Anh ---
        cards.add(MemoryCardItem(
          id: "${id}_en",
          text: word['en']!,
          pairId: id,
        ));
        
        // --- Thẻ 2: Random (Tiếng Việt HOẶC Icon) ---
        // Tỷ lệ 50/50 xuất hiện chữ hoặc icon
        bool showIcon = random.nextBool(); 
        String content = (showIcon && word['icon'] != null && word['icon'].toString().isNotEmpty)
            ? word['icon']! 
            : word['vi']!;

        cards.add(MemoryCardItem(
          id: "${id}_match", // Đặt tên suffix khác đi xíu
          text: content,
          pairId: id,
        ));
      }

      // 5. Xáo trộn vị trí các thẻ trên bàn cờ
      cards.shuffle(Random());
      
      return cards;
    } catch (e) {
      print("Error fetching memory card data: $e");
      return [];
    }
  }
}
