import 'vocab_question_model.dart';
import 'vocab_service.dart';

class VocabController {
  final VocabService service = VocabService();

  late List<VocabQuestion> questions;
  int index = 0;
  int score = 0;

  VocabController() {
    questions = service.loadQuestions();
  }

  VocabQuestion get currentQuestion => questions[index];

  bool answer(int choice) {
    bool correct = choice == currentQuestion.correct;
    if (correct) score++;
    return correct;
  }

  bool next() {
    if (index < questions.length - 1) {
      index++;
      return true;
    }
    return false; // đã hết câu hỏi
  }

  int total() => questions.length;
}
