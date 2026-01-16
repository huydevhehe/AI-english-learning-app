import 'package:flutter/material.dart';
import '../models/questions_model.dart';
import '../services/questions_service.dart';

class QuestionController extends ChangeNotifier {
  final QuestionService _service = QuestionService();

  List<QuestionModel> questions = [];
  bool isLoading = false;
  String? errorMessage;

  /// Load dữ liệu câu hỏi theo category (simple_present, simple_past...)
  Future<void> loadQuestions(String categoryId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      questions = await _service.getQuestions(categoryId);

      if (questions.isEmpty) {
        errorMessage = "Không tìm thấy dữ liệu câu hỏi.";
      }
    } catch (e) {
      errorMessage = "Lỗi tải dữ liệu: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
