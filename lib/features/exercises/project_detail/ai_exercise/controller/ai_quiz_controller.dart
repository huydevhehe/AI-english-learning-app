import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ai_quiz.dart';
import '../services/ai_quiz_service.dart';

class AiQuizController extends ChangeNotifier {
  final AiQuizService _service = AiQuizService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔑 BẮT BUỘC PHẢI CÓ projectId
  final String projectId;

  AiQuizController({required this.projectId});

  bool loading = false;
  String? error;
  AiQuiz? previewQuiz;

  // =========================
  // AI GENERATE (KHÔNG ĐỔI LOGIC)
  // =========================
  Future<void> generate({
    required String topic,
    required int count,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      previewQuiz = await _service.generateQuiz(
        topic: topic,
        count: count,
      );
    } catch (e) {
      final msg = e.toString();

      if (msg.contains('INVALID_TOPIC')) {
        error =
            'Chủ đề không phù hợp.\nVui lòng chọn chủ đề học tiếng Anh mang tính giáo dục.';
      } else if (msg.contains('400')) {
        error = 'Dữ liệu gửi lên không hợp lệ. Vui lòng thử lại.';
      } else if (msg.contains('AI_NO_RESPONSE')) {
        error = 'AI không phản hồi. Vui lòng thử lại sau.';
      } else {
        error = 'Có lỗi xảy ra khi tạo bài tập. Vui lòng thử lại.';
      }
    }

    loading = false;
    notifyListeners();
  }

  // =========================
  // 💾 LƯU FIRESTORE (CÁI M THIẾU)
  // =========================
  Future<void> saveQuiz({
    required String title,
  }) async {
    if (previewQuiz == null) return;

    loading = true;
    error = null;
    notifyListeners();

    final quiz = previewQuiz!;
    quiz.title = title;

    try {
      await _db
          .collection('projects')
          .doc(projectId)
          .collection('ai_quizzes')
          .add({
        'title': quiz.title,
        'intro': quiz.intro,
        'createdAt': FieldValue.serverTimestamp(),
        'questions': quiz.questions.map((q) {
          return {
            'question': q.question,
            'correctAnswer': q.correctAnswer,
            'options': q.options.map((o) {
              return {
                'key': o.key,
                'text': o.text,
              };
            }).toList(),
          };
        }).toList(),
      });

      // reset preview sau khi lưu
      previewQuiz = null;
    } catch (e) {
      error = 'Không thể lưu bài tập. Vui lòng thử lại.';
      rethrow;
    }

    loading = false;
    notifyListeners();
  }
}
