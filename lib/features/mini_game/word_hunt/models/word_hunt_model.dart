class WordHuntQuestion {
  final String id;
  final String question; // Nghĩa tiếng Việt
  final List<String> options; // 4 lựa chọn (Tiếng Anh)
  final String correctAnswer; // Đáp án đúng
  final String icon; // Icon gợi ý

  WordHuntQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.icon,
  });
}
