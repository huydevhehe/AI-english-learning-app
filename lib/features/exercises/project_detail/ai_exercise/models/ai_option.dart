class AiOption {
  String key;
  String text;

  AiOption({required this.key, required this.text});

  factory AiOption.fromJson(Map<String, dynamic> json) {
    return AiOption(
      key: json['key'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'text': text,
      };
}
