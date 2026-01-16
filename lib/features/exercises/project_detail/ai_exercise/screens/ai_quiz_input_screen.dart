import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/ai_quiz_controller.dart';
import 'ai_quiz_review_screen.dart';

class AiQuizInputScreen extends StatefulWidget {
  const AiQuizInputScreen({super.key});

  @override
  State<AiQuizInputScreen> createState() => _AiQuizInputScreenState();
}

class _AiQuizInputScreenState extends State<AiQuizInputScreen> {
  final topicCtrl = TextEditingController();
  int count = 10;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AiQuizController>();

    return Scaffold(
      appBar: AppBar(title: const Text('AI tạo bài tập')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: topicCtrl,
              decoration: const InputDecoration(
                labelText: 'Đề tài (liên quan tiếng Anh)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: count,
              items: List.generate(
                20,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${i + 1} câu'),
                ),
              ),
              onChanged: (v) => setState(() => count = v!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số câu (max 20)',
              ),
            ),
            const SizedBox(height: 20),
            if (c.loading) const CircularProgressIndicator(),
            if (c.error != null)
              Text(c.error!, style: const TextStyle(color: Colors.red)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                await c.generate(
                  topic: topicCtrl.text,
                  count: count,
                );
                if (c.previewQuiz != null && context.mounted) {
                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<AiQuizController>(),
      child: const AiQuizReviewScreen(),
    ),
  ),
);

                }
              },
              child: const Text('Tạo bài tập'),
            ),
          ],
        ),
      ),
    );
  }
}
