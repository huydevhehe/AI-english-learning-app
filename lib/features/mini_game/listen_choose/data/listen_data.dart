import '../models/listen_model.dart';

final listenData = [
  // ===== LEVEL 1 =====
  ListenQuestion(
    level: ListenLevel.word1,
    textToSpeak: "dog",
    options: ["Dog", "Cat", "Cow", "Bird"],
    correctIndex: 0,
  ),
  ListenQuestion(
    level: ListenLevel.word1,
    textToSpeak: "apple",
    options: ["Apple", "Orange", "Banana", "Grape"],
    correctIndex: 0,
  ),

  // ===== LEVEL 2 =====
  ListenQuestion(
    level: ListenLevel.word3,
    textToSpeak: "red apple tree",
    options: [
      "Red apple tree",
      "Green apple tree",
      "Red banana tree",
      "Big apple tree",
    ],
    correctIndex: 0,
  ),
  ListenQuestion(
    level: ListenLevel.word3,
    textToSpeak: "small black dog",
    options: [
      "Small black dog",
      "Big black dog",
      "Small white dog",
      "Big white dog",
    ],
    correctIndex: 0,
  ),

  // ===== LEVEL 3 =====
  ListenQuestion(
    level: ListenLevel.sentence,
    textToSpeak: "I like eating apples",
    options: [
      "I like eating apples",
      "I like eating bananas",
      "I like drinking water",
      "I like playing football",
    ],
    correctIndex: 0,
  ),
  ListenQuestion(
    level: ListenLevel.sentence,
    textToSpeak: "She is reading a book",
    options: [
      "She is reading a book",
      "She is writing a letter",
      "She is watching TV",
      "She is cooking food",
    ],
    correctIndex: 0,
  ),
];
