import 'package:flutter/material.dart';
import '../models/grammar_lesson_model.dart';
import '../services/grammar_service.dart';

class GrammarController extends ChangeNotifier {
  final GrammarService _service = GrammarService();

  List<GrammarLessonModel> lessons = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadLessons() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      lessons = await _service.getLessons();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
