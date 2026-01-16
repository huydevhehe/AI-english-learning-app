import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/listen_controller.dart';

class ListenScreen extends StatelessWidget {
  const ListenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListenController()..startGame(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ListenController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nghe & Chọn"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "⏱ ${c.timeLeft}s",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔊 Nghe (có thể nghe lại)
            ElevatedButton.icon(
              onPressed: c.play,
              icon: const Icon(Icons.volume_up),
              label: const Text("Nghe lại"),
            ),

            const SizedBox(height: 24),

            // 🎯 Danh sách đáp án
            ...List.generate(c.current.options.length, (i) {
              Color color = Colors.grey.shade200;

              if (c.selected != null) {
                if (i == c.current.correctIndex) {
                  color = Colors.green;
                } else if (i == c.selected) {
                  color = Colors.red;
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  // ⛔ khoá nút khi đã chọn
                  onPressed: c.selected == null ? () => c.choose(i) : null,
                  child: Text(
                    c.current.options[i],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),

            const Spacer(),

            // 📊 Thông tin điểm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "✅ Đúng: ${c.correct}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "❌ Sai: ${c.wrong}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // 🏁 Hết game
            if (c.isFinished && c.selected != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Kết thúc"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
