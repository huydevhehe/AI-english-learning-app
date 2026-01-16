import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Map<int, int> answers;

  const ResultView({
    super.key,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    int correct = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i]['correctIndex']) {
        correct++;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Kết quả: $correct / ${questions.length}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        ...List.generate(questions.length, (i) {
          final q = questions[i];
          final correctIndex = q['correctIndex'];
          final selected = answers[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q['question'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đáp án của bạn: ${q['options'][selected]}',
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      selected == correctIndex
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: selected == correctIndex
                          ? Colors.green
                          : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      selected == correctIndex
                          ? 'Đúng'
                          : 'Sai',
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
