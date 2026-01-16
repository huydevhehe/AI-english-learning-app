class AssessmentQuestion {
  final String skill;
  final String question;
  final List<Map<String, dynamic>> options;
  final String correctAnswer;

  String? userAnswer;

  AssessmentQuestion({
    required this.skill,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      skill: json['skill']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: (json['options'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      correctAnswer: json['correctAnswer']?.toString() ?? '',
    );
  }
}
