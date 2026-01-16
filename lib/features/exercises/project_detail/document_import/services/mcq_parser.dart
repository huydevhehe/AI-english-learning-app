import '../../manual_create/models/mcq_question_form.dart';

class McqParseResult {
  final List<McqQuestionForm> questions;
  final List<int> invalidIndexes;

  McqParseResult({
    required this.questions,
    required this.invalidIndexes,
  });
}

class McqParser {
  /// Parse + báo lỗi câu nào sai
  static McqParseResult parseWithReport(String raw) {
    final lines = raw.split('\n');

    final questions = <McqQuestionForm>[];
    final invalidIndexes = <int>[];

    McqQuestionForm? current;
    int questionIndex = -1;

    void flush() {
      if (current == null) return;

      final valid = current!.questionCtrl.text.isNotEmpty &&
          current!.optionCtrls.every((o) => o.text.isNotEmpty) &&
          current!.correctIndex >= 0;

      if (valid) {
        questions.add(current!);
      } else {
        invalidIndexes.add(questionIndex);
      }

      current = null;
    }

    for (final line in lines) {
      final l = line.trim();

      if (l.startsWith('Câu')) {
        flush();
        questionIndex++;

        current = McqQuestionForm();
        current!.questionCtrl.text =
            l.replaceFirst(RegExp(r'Câu\s*\d+:\s*'), '');
      } else if (l.startsWith('A.')) {
        current?.optionCtrls[0].text = l.substring(2).trim();
      } else if (l.startsWith('B.')) {
        current?.optionCtrls[1].text = l.substring(2).trim();
      } else if (l.startsWith('C.')) {
        current?.optionCtrls[2].text = l.substring(2).trim();
      } else if (l.startsWith('D.')) {
        current?.optionCtrls[3].text = l.substring(2).trim();
      } else if (l.toLowerCase().startsWith('đáp án')) {
        final ans = l.split(':').last.trim().toUpperCase();
        current?.correctIndex =
            ['A', 'B', 'C', 'D'].indexOf(ans);
      }
    }

    flush();

    return McqParseResult(
      questions: questions,
      invalidIndexes: invalidIndexes,
    );
  }

  /// Parse nhanh (nếu không cần report)
  static List<McqQuestionForm> parse(String raw) {
    return parseWithReport(raw).questions;
  }
}
