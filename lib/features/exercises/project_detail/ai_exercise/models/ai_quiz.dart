import 'ai_question.dart';

class AiQuiz {
  String title;
  String? intro; // 👈 AI nói 1 câu
  List<AiQuestion> questions;

  AiQuiz({
    required this.title,
    this.intro,
    required this.questions,
  });

  factory AiQuiz.fromJson(Map<String, dynamic> json) {
    return AiQuiz(
      title: json['title'],
      intro: json['intro'], // 👈 lấy intro từ AI
      questions: (json['questions'] as List)
          .map((e) => AiQuestion.fromJson(e))
          .toList(),
    );
  }
}
