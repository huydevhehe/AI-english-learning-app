import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/assessment_question.dart';

class AssessmentTestService {
  static String get _endpoint {
    if (kReleaseMode) {
      return "https://us-central1-my-app-english-c87dd.cloudfunctions.net/generateAssessmentTest";
    }
    return "http://127.0.0.1:5001/my-app-english-c87dd/us-central1/generateAssessmentTest";
  }

  Future<List<AssessmentQuestion>> loadTest() async {
    final res = await http.post(
      Uri.parse(_endpoint),
      headers: const {"Content-Type": "application/json"},
      body: jsonEncode({}),
    );

    if (res.statusCode != 200) {
      throw Exception("LOAD_ASSESSMENT_FAILED");
    }

    final Map<String, dynamic> data = jsonDecode(res.body);
    final List questions = data['questions'];

    return questions
        .map((e) => AssessmentQuestion.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();
  }
}
