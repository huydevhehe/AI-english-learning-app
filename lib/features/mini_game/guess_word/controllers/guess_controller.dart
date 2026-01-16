import 'dart:math';
import 'package:flutter/material.dart';
import '../data/guess_data.dart';
import '../models/guess_model.dart';

class GuessController extends ChangeNotifier {
  late GuessWord current;
  final Set<String> guessed = {};
  int lives = 6;

  void startGame(String topic) {
    final list = guessData.where((e) => e.topic == topic).toList();
    list.shuffle(Random());

    current = list.first;
    guessed.clear();
    lives = 6;
    notifyListeners();
  }

  void guess(String letter) {
    if (guessed.contains(letter)) return;

    guessed.add(letter);
    if (!current.answer.contains(letter)) {
      lives--;
    }
    notifyListeners();
  }

  bool isWin() =>
      current.answer.split("").every((c) => guessed.contains(c));
}
