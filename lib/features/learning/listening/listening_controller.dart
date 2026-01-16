import 'dart:math';
import 'package:flutter/material.dart';
import 'listening_question_model.dart';
import 'listening_service.dart';
import '../../../core/utils/sound_effect.dart';

enum ListeningMode {
  input,  // điền tay
  choice, // chọn đáp án
}

class ListeningController extends ChangeNotifier {
  final ListeningService _service = ListeningService();

  List<ListeningQuestion> _questions = [];
  int _currentIndex = 0;

  ListeningMode _mode = ListeningMode.choice;

  bool? isCorrect;

  ListeningQuestion? get currentQuestion =>
      _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  ListeningMode get mode => _mode;

  int get currentIndex => _currentIndex;
  int get total => _questions.length;

  /// Load dữ liệu + random
  Future<void> loadQuestions() async {
    _questions = await _service.fetchListeningQuestions();
    _questions.shuffle();

    _currentIndex = 0;
    _randomMode();
    notifyListeners();
  }

  /// Random kiểu bài (giống Duolingo)
  void _randomMode() {
    _mode = Random().nextBool()
        ? ListeningMode.input
        : ListeningMode.choice;
  }

  /// Câu hiển thị có ___
  String get displaySentence {
    final q = currentQuestion;
    if (q == null) return '';

    return q.fullSentence.replaceFirst(
      
      q.missingWord,
      '___',
    );
  }

  /// Nộp đáp án
  void submitAnswer(String answer) {
  final correct =
      currentQuestion!.missingWord.toLowerCase().trim();

  isCorrect = answer.toLowerCase().trim() == correct;

  if (isCorrect == true) {
    SoundEffect.playCorrect();
  } else {
    SoundEffect.playWrong();
  }

  notifyListeners();
}

  /// Sang câu tiếp theo
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      isCorrect = null;
      _randomMode();
      notifyListeners();
    }
  }
}
