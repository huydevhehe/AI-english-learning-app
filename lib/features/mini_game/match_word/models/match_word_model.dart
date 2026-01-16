class MatchWordPair {
  final String vi;
  final String en;
  final String icon;

  MatchWordPair({
    required this.vi,
    required this.en,
    required this.icon,
  });

  factory MatchWordPair.fromMap(Map<String, dynamic> map) {
    return MatchWordPair(
      vi: map['vi'] ?? '',
      en: map['en'] ?? '',
      icon: map['icon'] ?? '',
    );
  }
}
