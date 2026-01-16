import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_hunt_model.dart';

class WordHuntService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<WordHuntQuestion>> getQuestions(int count) async {
    try {
      List<Map<String, dynamic>> allWords = [];

      final querySnapshot = await _db.collection('miniGameWords').get();

      if (querySnapshot.docs.isEmpty) return [];

      // Gộp từ vựng từ tất cả topic
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

      if (allWords.length < 4) return []; // Không đủ từ để tạo đáp án sai

      final random = Random();
      // Shuffle để lấy câu hỏi ngẫu nhiên
      List<Map<String, dynamic>> questionPool = List.from(allWords)..shuffle(random);
      if (questionPool.length > count) {
        questionPool = questionPool.sublist(0, count);
      }

      List<WordHuntQuestion> questions = [];

      for (var qItem in questionPool) {
        final correctAnswer = qItem['word'] ?? '';
        final meaning = qItem['meaning'] ?? '';
        final icon = qItem['icon'] ?? '';
        final id = correctAnswer;

        // Tạo 3 đáp án sai
        Set<String> wrongAnswers = {};
        while (wrongAnswers.length < 3) {
          final randomWord = allWords[random.nextInt(allWords.length)];
          final w = randomWord['word'];
          if (w != correctAnswer && !wrongAnswers.contains(w)) {
            wrongAnswers.add(w);
          }
        }

        List<String> options = [correctAnswer, ...wrongAnswers];
        options.shuffle(random);

        questions.add(WordHuntQuestion(
          id: id,
          question: meaning,
          options: options,
          correctAnswer: correctAnswer,
          icon: icon,
        ));
      }

      return questions;

    } catch (e) {
      print("Error fetching word hunt data: $e");
      return [];
    }
  }
}
