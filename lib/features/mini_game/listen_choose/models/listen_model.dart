enum ListenLevel { word1, word3, sentence }

class ListenQuestion {
  final ListenLevel level;
  final String textToSpeak;
  final List<String> options;
  final int correctIndex;

  ListenQuestion({
    required this.level,
    required this.textToSpeak,
    required this.options,
    required this.correctIndex,
  });
}
