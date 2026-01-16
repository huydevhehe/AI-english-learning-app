import 'ai_option.dart';

class AiQuestion {
  String question;
  List<AiOption> options;
  String correctAnswer;

  AiQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory AiQuestion.fromJson(Map<String, dynamic> json) {
    return AiQuestion(
      question: json['question'],
      correctAnswer: json['correctAnswer'],
      options: (json['options'] as List)
          .map((e) => AiOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'correctAnswer': correctAnswer,
        'options': options.map((e) => e.toJson()).toList(),
      };
}
