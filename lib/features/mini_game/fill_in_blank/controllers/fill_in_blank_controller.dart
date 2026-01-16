import 'package:flutter/material.dart';
import '../models/fill_in_blank_model.dart';
import '../services/fill_in_blank_service.dart';

class FillInBlankController extends ChangeNotifier {
  final FillInBlankService _service = FillInBlankService();

  List<FillInBlankQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  
  bool _isAnswered = false;
  bool _isCorrect = false;

  List<FillInBlankQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isLoading => _isLoading;
  bool get isAnswered => _isAnswered;
  bool get isCorrect => _isCorrect;

  FillInBlankQuestion? get currentQuestion => 
      _questions.isNotEmpty ? _questions[_currentIndex] : null;

  FillInBlankController() {
    startGame();
  }

  Future<void> startGame() async {
    _isLoading = true;
    _score = 0;
    _currentIndex = 0;
    _isAnswered = false;
    notifyListeners();

    _questions = await _service.getQuestions(5); // Lấy 5 câu hỏi
    
    _isLoading = false;
    notifyListeners();
  }

  void checkAnswer(String userAnswer) {
    if (_isAnswered || currentQuestion == null) return;

    final correct = currentQuestion!.correctAnswer.trim().toLowerCase();
    final user = userAnswer.trim().toLowerCase();

    _isCorrect = user == correct;
    if (_isCorrect) {
      _score += 10;
    }
    _isAnswered = true;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _isAnswered = false;
      notifyListeners();
    } else {
      // Game over logic handled in view
    }
  }
}
