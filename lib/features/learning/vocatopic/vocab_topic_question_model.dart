class VocabTopicQuestion {
  final String question;
  final List<String> answers;
  final int correct;
  final String? icon;

  VocabTopicQuestion({
    required this.question,
    required this.answers,
    required this.correct,
    this.icon,
  });

  factory VocabTopicQuestion.fromMap(Map<String, dynamic> map) {
    return VocabTopicQuestion(
      question: map['question'] ?? '',
      answers: List<String>.from(map['answers'] ?? []),
      correct: map['correct'] ?? 0,
      icon: map['icon'],
    );
  }
}
