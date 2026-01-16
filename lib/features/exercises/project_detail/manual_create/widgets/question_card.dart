import 'package:flutter/material.dart';
import '../models/mcq_question_form.dart';

class QuestionCard extends StatefulWidget {
  final int index;
  final McqQuestionForm form;
  final VoidCallback onDelete;

  const QuestionCard({
    super.key,
    required this.index,
    required this.form,
    required this.onDelete,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    final form = widget.form;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEEF2FF),
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Câu ${widget.index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.grey.shade600,
                  onPressed: widget.onDelete,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ===== QUESTION =====
            TextField(
              controller: form.questionCtrl,
              decoration: InputDecoration(
                hintText: 'Nhập câu hỏi',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ===== OPTIONS =====
            ...List.generate(form.optionCtrls.length, (i) {
              final isCorrect = form.correctIndex == i;

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFFE8F0FF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCorrect
                        ? const Color(0xFF6C63FF)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: form.correctIndex,
                      activeColor: const Color(0xFF6C63FF),
                      onChanged: (v) {
                        setState(() => form.correctIndex = v!);
                      },
                    ),
                    Expanded(
                      child: TextField(
  controller: form.optionCtrls[i],
  onChanged: (v) {
    // 🔥 ép đảm bảo luôn là String
    form.optionCtrls[i].text = v;
  },
  decoration: InputDecoration(
    hintText: 'Đáp án ${i + 1}',
    border: InputBorder.none,
  ),
),

                    ),
                    if (form.optionCtrls.length > 2)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            form.removeOption(i);
                          });
                        },
                      ),
                  ],
                ),
              );
            }),

            // ===== ADD OPTION =====
            if (form.optionCtrls.length < 5)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    form.addOption();
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm đáp án'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6C63FF),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
