import 'package:flutter/material.dart';
import '../models/questions_model.dart';

class ResultWidget extends StatelessWidget {
  final List<QuestionModel> questions;
  final Map<int, int> selectedAnswers;

  const ResultWidget({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    int correctCount = 0;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].answer) {
        correctCount++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("KẾT QUẢ BÀI LÀM"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ⭐ Hiển thị tổng điểm
            Center(
              child: Text(
                "Bạn đúng $correctCount / ${questions.length}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ Danh sách câu hỏi + đáp án
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  final userPick = selectedAnswers[index];
                  final correctIndex = q.answer;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ⭐ Câu hỏi
                          Text(
                            "Câu ${index + 1}: ${q.question}",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// ⭐ 4 lựa chọn
                          Column(
                            children: List.generate(q.options.length, (
                              optIndex,
                            ) {
                              final option = q.options[optIndex];

                              bool isCorrect = optIndex == correctIndex;
                              bool isUserPick = optIndex == userPick;

                              Color bgColor = Theme.of(context).cardColor;
                              Color borderColor = Theme.of(
                                context,
                              ).dividerColor;

                              if (isCorrect) {
                                bgColor = Colors.green.shade100;
                                borderColor = Colors.green;
                              }

                              if (!isCorrect && isUserPick) {
                                bgColor = Colors.red.shade100;
                                borderColor = Colors.red;
                              }

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                  color: bgColor,
                                ),
                                child: ListTile(
                                  title: Text(
                                    option,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: isCorrect
                                              ? const Color.fromARGB(255, 5, 199, 105)
                                              : (!isCorrect && isUserPick)
                                              ? Colors.redAccent
                                              : Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium!.color,
                                        ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 10),

                          /// ⭐ Giải thích
                          Text(
                            "Giải thích: ${q.explanation}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall!.color?.withOpacity(0.8),

                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
