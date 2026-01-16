import 'dart:math';
import 'package:flutter/material.dart';
import '../data/scramble_data.dart';
import '../models/scramble_model.dart';

class ScrambleController extends ChangeNotifier {
  late List<ScrambleWord> _pool;
  late ScrambleWord current;

  List<String> letters = [];
  List<String> selected = [];

  void startGame(String topic) {
    _pool = scrambleData.where((e) => e.topic == topic).toList();

    if (_pool.isEmpty) {
      debugPrint('❌ Scramble: không có data cho topic = $topic');
      return;
    }

    _nextWord();
  }

  void _nextWord() {
    _pool.shuffle(Random());
    current = _pool.first;

    letters = current.answer.split("")..shuffle();
    selected.clear();
    notifyListeners();
  }

  void selectLetter(String l) {
    if (selected.length < current.answer.length) {
      selected.add(l);
      notifyListeners();
    }
  }

  void removeLast() {
    if (selected.isNotEmpty) {
      selected.removeLast();
      notifyListeners();
    }
  }

  bool isCorrect() => selected.join() == current.answer;

  /// 👉 GỌI SAU KHI BẤM "KIỂM TRA"
  void submit() {
    if (isCorrect()) {
      _nextWord();        // đúng → sang từ mới
    } else {
      selected.clear();  // sai → cho chọn lại
      notifyListeners();
    }
  }
}
