class ReadingPassage {
  final String id;
  final String title;
  final String content;
  final List<ReadingQuestion> questions;

  ReadingPassage({
    required this.id,
    required this.title,
    required this.content,
    required this.questions,
  });

  factory ReadingPassage.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ReadingPassage(
      id: id,
      title: map['title'],
      content: map['content'],
      questions: (map['questions'] as List)
          .map((q) => ReadingQuestion.fromMap(q))
          .toList(),
    );
  }
}

class ReadingQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  String? userAnswer;

  ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.userAnswer,
  });

  factory ReadingQuestion.fromMap(Map<String, dynamic> map) {
    return ReadingQuestion(
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswer: map['correctAnswer'],
    );
  }
}
