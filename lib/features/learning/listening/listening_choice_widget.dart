import 'package:flutter/material.dart';

class ListeningChoiceWidget extends StatelessWidget {
  final List<String> options;
  final Function(String) onSelect;

  /// đáp án user chọn
  final String? selected;

  /// đáp án đúng
  final String? correct;

  const ListeningChoiceWidget({
    super.key,
    required this.options,
    required this.onSelect,
    this.selected,
    this.correct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: options.map((option) {
        final bool isCorrect = option == correct;
        final bool isSelected = option == selected;

        Color bgColor;
        Color borderColor;
        Color textColor;

        // ===== TRẠNG THÁI =====
        if (isCorrect) {
          // ✅ đúng
          bgColor = Colors.green.shade100;
          borderColor = Colors.green;
          textColor = Colors.green.shade800;
        } else if (isSelected && !isCorrect) {
          // ❌ sai
          bgColor = const Color.fromARGB(255, 194, 47, 47);
          borderColor = const Color.fromARGB(255, 219, 44, 32);
          textColor = const Color.fromARGB(255, 196, 46, 46);
        } else {
          // bình thường (ăn theo theme)
          bgColor = theme.cardColor;
          borderColor = theme.dividerColor;
          textColor = theme.textTheme.bodyLarge!.color!;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (selected == null) {
                onSelect(option);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
