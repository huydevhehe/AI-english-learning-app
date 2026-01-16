import 'package:flutter/material.dart';
import '../models/match_word_model.dart';
import '../services/match_word_service.dart';

enum MatchStatus { none, selecting, correct, wrong }

class MatchWordController extends ChangeNotifier {
  final MatchWordService _service = MatchWordService();

  List<MatchWordPair> _pairs = [];
  List<String> leftSide = [];
  List<String> rightSide = [];
  
  String? selectedLeft;
  String? selectedRight;
  
  final Set<String> matchedLeft = {}; // Lưu từ tiếng Việt đã ghép
  final Set<String> matchedRight = {}; // Lưu từ tiếng Anh đã ghép
  
  MatchStatus currentStatus = MatchStatus.none;

  int score = 0;
  bool isLoading = true;

  MatchWordController() {
    startGame();
  }

  Future<void> startGame() async {
    // RESET STATE TRƯỚC khi notify để tránh lỗi hiện dialog lần 2
    matchedLeft.clear();
    matchedRight.clear();
    selectedLeft = null;
    selectedRight = null;
    score = 0;
    currentStatus = MatchStatus.none;
    isLoading = true; 
    notifyListeners();

    _pairs = await _service.getRandomWords(5); // Lấy 5 cặp
    
    leftSide = _pairs.map((e) => e.vi).toList();
    rightSide = _pairs.map((e) => e.en).toList();
    
    leftSide.shuffle();
    rightSide.shuffle();
    
    isLoading = false;
    notifyListeners();
  }

  void selectLeft(String word) {
    if (matchedLeft.contains(word) || currentStatus != MatchStatus.none) return;
    
    // Nếu đang chọn lại chính nó thì bỏ chọn
    if (selectedLeft == word) {
      selectedLeft = null;
    } else {
      selectedLeft = word;
    }
    _checkMatch();
    notifyListeners();
  }

  void selectRight(String word) {
    if (matchedRight.contains(word) || currentStatus != MatchStatus.none) return;

    // Nếu đang chọn lại chính nó thì bỏ chọn
    if (selectedRight == word) {
      selectedRight = null;
    } else {
      selectedRight = word;
    }
    _checkMatch();
    notifyListeners();
  }

  void _checkMatch() {
    // Chỉ check khi đã chọn cả 2 bên
    if (selectedLeft != null && selectedRight != null) {
      final pair = _pairs.firstWhere(
        (e) => e.vi == selectedLeft && e.en == selectedRight,
        orElse: () => MatchWordPair(vi: '', en: '', icon: ''),
      );

      if (pair.vi.isNotEmpty) {
        // --- ĐÚNG ---
        currentStatus = MatchStatus.correct; // Chuyển trạng thái sang "Correct" (Màu xanh)
        notifyListeners();

        // Delay 1 chút để hiện màu xanh trước khi ẩn
        Future.delayed(const Duration(milliseconds: 500), () {
          matchedLeft.add(selectedLeft!);
          matchedRight.add(selectedRight!);
          score += 10;
          
          // Reset selection
          selectedLeft = null;
          selectedRight = null;
          currentStatus = MatchStatus.none;
          notifyListeners();
        });

      } else {
        // --- SAI ---
        currentStatus = MatchStatus.wrong; // Chuyển trạng thái sang "Wrong" (Màu đỏ)
        notifyListeners();

        // Delay để hiện màu đỏ
        Future.delayed(const Duration(milliseconds: 600), () {
          selectedLeft = null;
          selectedRight = null;
          currentStatus = MatchStatus.none;
          notifyListeners();
        });
      }
    }
  }

  bool isGameCompleted() {
    return _pairs.isNotEmpty && matchedLeft.length == _pairs.length;
  }
}
