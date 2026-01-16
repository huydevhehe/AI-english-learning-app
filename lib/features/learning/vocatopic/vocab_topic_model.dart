class VocabTopicModel {
  final String id;
  final String topicKey;
  final String title;
  final String emoji;
  final int totalWords;
  final int completed;

  VocabTopicModel({
    required this.id,
    required this.topicKey,
    required this.title,
    required this.emoji,
    required this.totalWords,
    required this.completed,
  });

  factory VocabTopicModel.fromMap(String id, Map<String, dynamic> map) {
    return VocabTopicModel(
      id: id,
      topicKey: map['topicKey'],
      title: map['title'],
      emoji: map['emoji'],
      totalWords: map['totalWords'],
      completed: 0,
    );
  }
}
