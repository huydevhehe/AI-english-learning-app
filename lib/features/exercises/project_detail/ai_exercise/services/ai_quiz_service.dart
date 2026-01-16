import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_quiz.dart';
import 'package:flutter/foundation.dart';

class AiQuizService {
  static String get _endpoint {
    if (kReleaseMode) {
      return "https://us-central1-my-app-english-c87dd.cloudfunctions.net/generateMcqQuiz";
    }
    return "http://127.0.0.1:5001/my-app-english-c87dd/us-central1/generateMcqQuiz";
  }

  Future<AiQuiz> generateQuiz({
    required String topic,
    required int count,
  }) async {
    final res = await http.post(
      Uri.parse(_endpoint),
      headers: const {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "topic": topic,
        "count": count,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("AI lỗi ${res.statusCode}: ${res.body}");
    }

    return AiQuiz.fromJson(jsonDecode(res.body));
  }
}
