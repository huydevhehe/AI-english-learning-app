class MemoryCardItem {
  final String id;
  final String text;
  final String pairId; // ID của cặp (ví dụ: 'dog' sẽ pair với 'con chó')
  bool isFlipped;
  bool isMatched;

  MemoryCardItem({
    required this.id,
    required this.text,
    required this.pairId,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
