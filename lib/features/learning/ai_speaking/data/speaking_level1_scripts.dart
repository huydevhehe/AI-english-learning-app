class SpeakingScript {
  final String id;
  final String sentence;

  const SpeakingScript({
    required this.id,
    required this.sentence,
  });
}

const level1Scripts = [
  SpeakingScript(
    id: "l1_1",
    sentence: "I really like learning English.",
  ),
  SpeakingScript(
    id: "l1_2",
    sentence: "I am learning English every day.",
  ),
  SpeakingScript(
    id: "l1_3",
    sentence: "English helps me communicate with people.",
  ),
];
