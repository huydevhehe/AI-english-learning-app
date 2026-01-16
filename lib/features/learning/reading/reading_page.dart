import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reading_controller.dart';
import '../../../core/services/dictionary_service.dart';
class ReadingPage extends StatelessWidget {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ CHỈ return UI, KHÔNG tạo Provider ở đây
    return const _ReadingView();
  }
}

class _ReadingView extends StatelessWidget {
  const _ReadingView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReadingController>();

    // 🔹 Loading
    if (controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 🔹 Error
    if (controller.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            controller.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // 🔹 Không có dữ liệu
    if (controller.passage == null) {
      return const Scaffold(
        body: Center(child: Text("Không có bài đọc")),
      );
    }

    final passage = controller.passage!;

    return Scaffold(
      appBar: AppBar(
        title: Text(passage.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ReadingText(passage.content),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: passage.questions.length,
                itemBuilder: (_, i) {
                  final q = passage.questions[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Câu ${i + 1}: ${q.question}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...q.options.map(
                            (opt) => RadioListTile<String>(
                              value: opt,
                              groupValue: q.userAnswer,
                              title: Text(opt),
                              onChanged: (v) {
                                controller.answerQuestion(i, v!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final result = controller.calculateResult();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Kết quả"),
                    content: Text(
                      "Đúng ${result.correct}/${result.total}\n"
                      "Điểm: ${result.score}%",
                    ),
                  ),
                );
              },
              child: const Text("Nộp bài"),
            ),
          ],
        ),
      ),
    );
  }
}

/// TAP TỪ → HIỆN NGHĨA (DEMO)
class _ReadingText extends StatelessWidget {
  final String text;
  const _ReadingText(this.text);

  @override
  Widget build(BuildContext context) {
    final words = text.split(RegExp(r'\s+'));
    final dictionary = DictionaryService();

    return Wrap(
      spacing: 6,
      runSpacing: 8,
      children: words.map((word) {
        return GestureDetector(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            final meaning = await dictionary.translateWord(word);

            Navigator.pop(context);

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(word),
                content: Text(meaning),
              ),
            );
          },
          child: Text(
            word,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}
