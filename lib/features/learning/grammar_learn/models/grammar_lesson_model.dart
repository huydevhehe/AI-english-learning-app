class GrammarLessonModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final List<String> examples;

  GrammarLessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.examples,
  });

  factory GrammarLessonModel.fromMap(Map<String, dynamic> data, String id) {
    return GrammarLessonModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      examples: List<String>.from(data['examples'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'examples': examples,
    };
  }
}
