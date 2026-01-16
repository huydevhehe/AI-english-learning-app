class ListeningQuestion {
  final String id;
  final String fullSentence;
  final String missingWord;
  final List<String> options;

  ListeningQuestion({
    required this.id,
    required this.fullSentence,
    required this.missingWord,
    required this.options,
  });

  factory ListeningQuestion.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ListeningQuestion(
      id: id,
      fullSentence: data['fullSentence'],
      missingWord: data['missingWord'],
      options: List<String>.from(data['options']),
    );
  }
}
