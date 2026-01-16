import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/fill_in_blank_controller.dart';
import '../models/fill_in_blank_model.dart';

class FillInBlankGameScreen extends StatelessWidget {
  const FillInBlankGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FillInBlankController(),
      child: const _FillInBlankGameView(),
    );
  }
}

class _FillInBlankGameView extends StatefulWidget {
  const _FillInBlankGameView();

  @override
  State<_FillInBlankGameView> createState() => _FillInBlankGameViewState();
}

class _FillInBlankGameViewState extends State<_FillInBlankGameView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showWinDialog(BuildContext context, FillInBlankController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Kết thúc! 🎉"),
        content: Text("Bạn đạt được số điểm: ${controller.score}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.startGame(); // Reset
              _textController.clear();
            },
            child: const Text("Chơi lại"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Exit
            },
            child: const Text("Thoát"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FillInBlankController>();
    final question = controller.currentQuestion;

    // Check game over
    // Logic này nên cẩn thận để ko show dialog nhiều lần
    if (question == null && !controller.isLoading) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted) _showWinDialog(context, controller);
       });
    }

    // Mỗi khi chuyển câu hỏi mới, clear text controller nếu chưa trả lời
    // Nhưng ta không thể clear trong build. Ta làm ở logic nextQuestion của controller hoặc lắng nghe.
    // Đơn giản nhất: clear khi nhấn nút Check (đã xử lý xong) hoặc Next.
    
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: const Text("Điền từ vào chỗ trống"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.startGame();
              _textController.clear();
            },
          )
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : question == null 
              ? const SizedBox() 
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Score
                      Text(
                        "Điểm: ${controller.score}",
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.teal
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 40),
                      
                      // Question Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Gợi ý: ${question.definition}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              controller.isAnswered ? question.fullSentence : question.question,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Input Field
                      if (!controller.isAnswered) ...[
                        TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nhập từ còn thiếu',
                            hintText: 'Ví dụ: Apple',
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                             if (value.isNotEmpty) {
                               controller.checkAnswer(value);
                             }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                             if (_textController.text.isNotEmpty) {
                               controller.checkAnswer(_textController.text);
                             }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            "Kiểm tra", 
                            style: TextStyle(fontSize: 18, color: Colors.white)
                          ),
                        ),
                      ] else ...[
                        // Feedback
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller.isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                controller.isCorrect ? Icons.check_circle : Icons.cancel,
                                color: controller.isCorrect ? Colors.green : Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.isCorrect 
                                    ? "Chính xác!" 
                                    : "Sai rồi. Đáp án là: ${question.correctAnswer}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: controller.isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _textController.clear();
                            controller.nextQuestion();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            "Câu tiếp theo", 
                            style: TextStyle(fontSize: 18, color: Colors.white)
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
