import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/guess_controller.dart';

class GuessScreen extends StatelessWidget {
  final String topic;
  const GuessScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuessController()..startGame(topic),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final TextEditingController _ctrl = TextEditingController();
  bool? isCorrect; // null = chưa đoán

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<GuessController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Đoán từ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ❤️ Mạng
            Text("❤️" * c.lives, style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 20),

            // 🧩 ICON / EMOJI (giả lập icon)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isCorrect == null
                    ? Colors.grey.shade200
                    : isCorrect == true
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                c.current.icon ?? "❓", // nếu có icon trong data
                style: const TextStyle(fontSize: 60),
              ),
            ),

            const SizedBox(height: 24),

            // ⌨️ Nhập từ
            TextField(
              controller: _ctrl,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Nhập từ bạn đoán",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // 🔘 Nút kiểm tra
            ElevatedButton(
              onPressed: () {
                final input = _ctrl.text.trim().toLowerCase();
                if (input.isEmpty) return;

                final answer = c.current.answer.toLowerCase();

                final correct = input == answer;
                setState(() => isCorrect = correct);

                if (!correct) {
                  c.lives--;
                }

                // đợi cho người chơi thấy kết quả
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (!mounted) return;

                  if (correct || c.lives <= 0) {
                    // sang từ mới
                    c.startGame(c.current.topic);
                  }

                  _ctrl.clear();
                  setState(() => isCorrect = null);
                });
              },
              child: const Text("Kiểm tra"),
            ),

            const SizedBox(height: 12),

            // ℹ️ Feedback chữ
            if (isCorrect != null)
              Text(
                isCorrect! ? "🎉 Chính xác!" : "❌ Sai rồi",
                style: TextStyle(
                  fontSize: 18,
                  color: isCorrect! ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
