class VocabQuestion {
  final String question;
  final List<String> answers;
  final int correct;

  // thêm animation
  final String? animation;

  // thêm icon (để dùng emoji trong câu hỏi)
  final String? icon;

  VocabQuestion({
    required this.question,
    required this.answers,
    required this.correct,
    this.animation,
    this.icon, // thêm đây
  });

  factory VocabQuestion.fromMap(Map<String, dynamic> map) {
    return VocabQuestion(
      question: map["q"] ?? "",
      answers: List<String>.from(map["a"] ?? []),
      correct: map["correct"] ?? 0,
      animation: map["animation"], // lấy animation nếu có
      icon: map["icon"], // lấy icon nếu có
    );
  }
}
