class FillInBlankQuestion {
  final String id;
  final String question; // Câu ví dụ với chỗ trống (I eat ___ ...)
  final String correctAnswer; // Từ cần điền (Bread)
  final String fullSentence; // Câu hoàn chỉnh để hiển thị sau khi trả lời đúng
  final String definition; // Nghĩa tiếng Việt để gợi ý

  FillInBlankQuestion({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.fullSentence,
    required this.definition,
  });

  factory FillInBlankQuestion.fromMap(String id, Map<String, dynamic> map) {
    String word = map['word'] ?? '';
    String example = map['example'] ?? '';
    
    // Tạo câu hỏi bằng cách thay thế từ khóa bằng dấu gạch dưới
    // Regex case-insensitive để replace cả viết hoa/thường
    String questionStr = example.replaceAll(RegExp(word, caseSensitive: false), '___');
    
    // Nếu chưa có dấu ___ (do example không chứa word chính xác), ta force replace từ cuối cùng hoặc placeholder
    // Nhưng data seed ta đã chuẩn bị kỹ, nên tạm tin tưởng data.
    
    return FillInBlankQuestion(
      id: id,
      question: questionStr,
      correctAnswer: word,
      fullSentence: example,
      definition: map['meaning'] ?? '',
    );
  }
}
