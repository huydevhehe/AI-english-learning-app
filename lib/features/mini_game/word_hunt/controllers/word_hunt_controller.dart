import 'package:flutter/material.dart';
import 'dart:async';
import '../models/word_hunt_model.dart';
import '../services/word_hunt_service.dart';

class WordHuntController extends ChangeNotifier {
  final WordHuntService _service = WordHuntService();

  List<WordHuntQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  
  bool _isAnswered = false;
  bool _isCorrect = false;
  String _selectedAnswer = '';
  
  // Trạng thái mới: Game Over (Thua cuộc)
  bool _isGameOver = false;

  // Timer
  Timer? _timer;
  int _timeLeft = 10; // 10 giây mỗi câu

  List<WordHuntQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isLoading => _isLoading;
  bool get isAnswered => _isAnswered;
  bool get isCorrect => _isCorrect;
  bool get isGameOver => _isGameOver;
  String get selectedAnswer => _selectedAnswer;
  int get timeLeft => _timeLeft;

  WordHuntQuestion? get currentQuestion => 
      _questions.isNotEmpty && _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  WordHuntController() {
    startGame();
  }

  Future<void> startGame() async {
    _timer?.cancel();
    _isLoading = true;
    _score = 0;
    _currentIndex = 0;
    _isAnswered = false;
    _isGameOver = false; // Reset game over
    _timeLeft = 10;
    notifyListeners();

    _questions = await _service.getQuestions(10); // Lấy 10 câu hỏi
    
    _isLoading = false;
    notifyListeners();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        // Hết giờ -> THUA CUỘC
        _timer?.cancel();
        _isGameOver = true; // Kích hoạt cờ Game Over
        notifyListeners();
      }
    });
  }

  void checkAnswer(String answer) {
    if (_isAnswered || currentQuestion == null || _isGameOver) return;
    
    _timer?.cancel();
    _selectedAnswer = answer;
    
    _isCorrect = answer == currentQuestion!.correctAnswer;

    if (_isCorrect) {
      _score += 10;
      _isAnswered = true;
      notifyListeners();
      
      // Tự động chuyển câu sau 1s nếu đúng
      Future.delayed(const Duration(seconds: 1), () {
        if (!_isGameOver) nextQuestion();
      });
    } else {
      // Trả lời sai -> Cũng coi như thua cuộc luôn? 
      // Hoặc chỉ thua khi hết giờ?
      // Theo yêu cầu của bạn: "hết thời gian chưa chọn được thì thông báo thua cuộc".
      // Nếu bạn muốn trả lời SAI cũng thua luôn thì uncomment dòng dưới:
      // _isGameOver = true; 
      
      _isAnswered = true;
      notifyListeners();
       Future.delayed(const Duration(seconds: 1), () {
        if (!_isGameOver) nextQuestion();
      });
    }
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _isAnswered = false;
      _selectedAnswer = '';
      _startTimer();
      notifyListeners();
    } else {
      // Hoàn thành tất cả câu hỏi -> Winner
      _timer?.cancel();
      // Không set isGameOver = true vì đây là thắng
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
