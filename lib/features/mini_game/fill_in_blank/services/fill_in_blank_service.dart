import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fill_in_blank_model.dart';

class FillInBlankService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<FillInBlankQuestion>> getQuestions(int count) async {
    try {
      List<Map<String, dynamic>> allWords = [];

      final querySnapshot = await _db.collection('miniGameWords').get();

      if (querySnapshot.docs.isEmpty) return [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        if (data.containsKey('words') && data['words'] is List) {
          final List<dynamic> wordsList = data['words'];
          for (var wordItem in wordsList) {
             if (wordItem is Map<String, dynamic>) {
               // Chỉ lấy từ có câu ví dụ
               if (wordItem['example'] != null && wordItem['example'].toString().isNotEmpty) {
                 allWords.add(wordItem);
               }
             }
          }
        }
      }

      allWords.shuffle(Random());
      if (allWords.length > count) {
        allWords = allWords.sublist(0, count);
      }

      return allWords.map((e) => FillInBlankQuestion.fromMap(e['word'] ?? 'ID', e)).toList();

    } catch (e) {
      print("Error fetching fill in blank data: $e");
      return [];
    }
  }
}
