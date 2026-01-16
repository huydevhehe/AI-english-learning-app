class QuestionModel {
  final String id;
  final String categoryId;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;

  QuestionModel({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  // Convert Firestore → Model
  factory QuestionModel.fromMap(Map<String, dynamic> data, String id) {
    return QuestionModel(
      id: id,
      categoryId: data['categoryId'] ?? '',
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      answer: data['answer'] ?? 0,
      explanation: data['explanation'] ?? '',
    );
  }

  // Convert Model → Map (nếu cần upload)
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'question': question,
      'options': options,
      'answer': answer,
      'explanation': explanation,
    };
  }
}
