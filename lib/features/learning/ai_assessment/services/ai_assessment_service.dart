import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiAssessmentService {
  static String get _endpoint {
    if (kReleaseMode) {
      return "https://us-central1-my-app-english-c87dd.cloudfunctions.net/evaluateSkillWithAI";
    }
    return "http://127.0.0.1:5001/my-app-english-c87dd/us-central1/evaluateSkillWithAI";
  }

  Future<Map<String, dynamic>> evaluate({
    required int totalQuestions,
    required int correctAnswers,
    required int timeSpentSeconds,
    required Map<String, dynamic> skills,
    required List<String> wrongQuestionTypes,
  }) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: const {"Content-Type": "application/json"},
      body: jsonEncode({
        "totalQuestions": totalQuestions,
        "correctAnswers": correctAnswers,
        "timeSpentSeconds": timeSpentSeconds,
        "skills": skills,
        "wrongQuestionTypes": wrongQuestionTypes,
      }),
    );

    debugPrint("AI EVALUATE STATUS: ${response.statusCode}");
    debugPrint("AI EVALUATE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("AI_EVALUATION_FAILED");
    }

    return jsonDecode(response.body);
  }
}
