import 'package:flutter/material.dart';
import 'reading_model.dart';
import 'reading_service.dart';

class ReadingController extends ChangeNotifier {
  final ReadingService _service = ReadingService();

  bool isLoading = false;
  String? error;

  ReadingPassage? passage;
  List<ReadingPassage> allPassages = [];

  /// Load danh sách bài
  Future<void> loadList() async {
    isLoading = true;
    notifyListeners();

    try {
      allPassages = await _service.getAllPassages();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Chọn bài cụ thể
  void selectPassage(ReadingPassage p) {
    passage = p;
    notifyListeners();
  }

  /// Random bài
  Future<void> loadRandom() async {
    isLoading = true;
    notifyListeners();

    passage = await _service.getRandomPassage();

    isLoading = false;
    notifyListeners();
  }

  // ======= PHẦN LÀM BÀI (GIỮ NGUYÊN LOGIC CŨ) =======

  void answerQuestion(int index, String answer) {
    passage!.questions[index].userAnswer = answer;
    notifyListeners();
  }

  ReadingResult calculateResult() {
    int correct = 0;
    for (final q in passage!.questions) {
      if (q.userAnswer == q.correctAnswer) {
        correct++;
      }
    }
    return ReadingResult(
      correct: correct,
      total: passage!.questions.length,
    );
  }
}

class ReadingResult {
  final int correct;
  final int total;

  ReadingResult({required this.correct, required this.total});

  int get score => ((correct / total) * 100).round();
}
