import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/scramble_controller.dart';

class ScrambleScreen extends StatelessWidget {
  final String topic;
  const ScrambleScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScrambleController()..startGame(topic),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ScrambleController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Xếp từ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Gợi ý: ${c.current.hint}",
                style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                c.current.answer.length,
                (i) => Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Text(
                    i < c.selected.length ? c.selected[i] : "",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              children: c.letters.map((e) {
                return ElevatedButton(
                  onPressed: () => c.selectLetter(e),
                  child: Text(e),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
  onPressed: () {
    final c = context.read<ScrambleController>();
    final isRight = c.isCorrect();

    // 1. Hiện thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 600),
        content: Text(isRight ? "🎉 Chính xác!" : "❌ Sai rồi"),
      ),
    );

    // 2. Đợi SnackBar hiện xong rồi mới xử lý game
    Future.delayed(const Duration(milliseconds: 600), () {
      c.submit();
    });
  },
  child: const Text("Kiểm tra"),
),

          ],
        ),
      ),
    );
  }
}
