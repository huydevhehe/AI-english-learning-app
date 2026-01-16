import 'package:flutter/material.dart';
import '../services/ai_assessment_service.dart';
import '../models/assessment_result.dart';

class AiAssessmentController extends ChangeNotifier {
  final _service = AiAssessmentService();

  bool isLoading = false;
  AssessmentResult? result;
  String? error;

  Future<void> submitTest({
    required int totalQuestions,
    required int correctAnswers,
    required int timeSpentSeconds,
    required Map<String, dynamic> skills,
    required List<String> wrongQuestionTypes,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _service.evaluate(
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        timeSpentSeconds: timeSpentSeconds,
        skills: skills,
        wrongQuestionTypes: wrongQuestionTypes,
      );

      result = AssessmentResult.fromJson(data);
    } catch (e) {
      error = "Không thể đánh giá năng lực. Vui lòng thử lại.";
      debugPrint("AI ASSESSMENT ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // 👈 BẮT BUỘC, thiếu là treo
    }
  }
}
