import 'package:flutter/material.dart';
class QuestionPlayCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedIndex;
  final int correctIndex;
  final bool showAnswer;
  final ValueChanged<int> onSelect;

  const QuestionPlayCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.correctIndex,
    required this.showAnswer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          ...List.generate(options.length, (i) {
            Color bg = Colors.grey.shade100;
            IconData icon = Icons.radio_button_off;

            if (showAnswer) {
              if (i == correctIndex) {
                bg = Colors.green.withOpacity(0.15);
                icon = Icons.check_circle;
              } else if (i == selectedIndex) {
                bg = Colors.red.withOpacity(0.15);
                icon = Icons.cancel;
              }
            } else if (i == selectedIndex) {
              bg = Colors.deepPurple.withOpacity(0.1);
              icon = Icons.radio_button_checked;
            }

            return GestureDetector(
              onTap: showAnswer ? null : () => onSelect(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(options[i])),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
