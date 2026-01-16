import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/ai_quiz_controller.dart';

class AiQuizReviewScreen extends StatefulWidget {
  const AiQuizReviewScreen({super.key});

  @override
  State<AiQuizReviewScreen> createState() => _AiQuizReviewScreenState();
}

class _AiQuizReviewScreenState extends State<AiQuizReviewScreen> {
  final TextEditingController titleCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AiQuizController>();
    final quiz = c.previewQuiz!;

    // luôn sync title
    titleCtrl.text = quiz.title;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem & chỉnh sửa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ====== TÊN BÀI TẬP ======
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Tên bài tập',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          /// ====== AI INTRO (NẾU CÓ) ======
          if (quiz.intro != null && quiz.intro!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
  "🤖",
  style: TextStyle(fontSize: 20),
),

                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quiz.intro!,
                      style: const TextStyle(
  fontSize: 14,
  height: 1.5,
  color: Colors.black87,
),

                    ),
                  ),
                ],
              ),
            ),

          /// ====== DANH SÁCH CÂU HỎI ======
          ...quiz.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final q = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Câu ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      initialValue: q.question,
                      onChanged: (v) => q.question = v,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung câu hỏi',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...q.options.map(
                      (o) => RadioListTile<String>(
                        value: o.key,
                        groupValue: q.correctAnswer,
                        onChanged: (v) {
                          setState(() {
                            q.correctAnswer = v!;
                          });
                        },
                        title: TextFormField(
                          initialValue: o.text,
                          onChanged: (v) => o.text = v,
                          decoration: InputDecoration(
                            labelText: 'Đáp án ${o.key}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          /// ====== NÚT LƯU ======
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
           onPressed: () async {
  await c.saveQuiz(
    title: titleCtrl.text,
  );

  if (!mounted) return;
  Navigator.pop(context);
},

            child: const Text('Lưu bài tập'),
          ),
        ],
      ),
    );
  }
}
