import 'dart:async';
import 'package:flutter/material.dart';
import '../data/listen_data.dart';
import '../models/listen_model.dart';
import '../services/tts_service.dart';

class ListenController extends ChangeNotifier {
  final TtsService _tts = TtsService();

  late ListenQuestion current;

  int index = 0;

  int correct = 0;
  int wrong = 0;

  int? selected; // null = chưa chọn
  int timeLeft = 0;

  Timer? _timer;

  // ===== PUBLIC API =====

  void startGame() {
    index = 0;
    correct = 0;
    wrong = 0;
    _loadQuestion();
  }

  /// 🔊 Bấm nút "Nghe lại"
  void play() {
    _tts.speak(current.textToSpeak);
  }

  /// 🎯 Chọn đáp án
  void choose(int i) {
    if (selected != null) return;

    selected = i;
    _timer?.cancel();

    if (i == current.correctIndex) {
      correct++;
    } else {
      wrong++;
    }

    notifyListeners();

    // ⏭ Sang câu tiếp theo sau 0.9s
    Future.delayed(const Duration(milliseconds: 900), _next);
  }

  bool get isFinished => index == listenData.length - 1;

  // ===== INTERNAL =====

  void _loadQuestion() async {
    current = listenData[index];
    selected = null;

    _startTimer();
    notifyListeners();

    // 🔊 Auto đọc khi vào câu
    await Future.delayed(const Duration(milliseconds: 300));
    _tts.speak(current.textToSpeak);
  }

  void _next() {
    if (index < listenData.length - 1) {
      index++;
      _loadQuestion();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    timeLeft = _timeByLevel(current.level);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timeLeft--;

      if (timeLeft <= 0) {
        t.cancel();
        selected = -1; // hết giờ
        wrong++;
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 900), _next);
      } else {
        notifyListeners();
      }
    });
  }

  int _timeByLevel(ListenLevel level) {
    switch (level) {
      case ListenLevel.word1:
        return 6;
      case ListenLevel.word3:
        return 5;
      case ListenLevel.sentence:
        return 4;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }
}
