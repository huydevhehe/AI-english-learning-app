import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/word_hunt_controller.dart';
import '../models/word_hunt_model.dart';

class WordHuntGameScreen extends StatelessWidget {
  const WordHuntGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordHuntController(),
      child: const _WordHuntGameView(),
    );
  }
}

class _WordHuntGameView extends StatelessWidget {
  const _WordHuntGameView();

  // Dialog thắng (Hết câu hỏi)
  void _showWinDialog(BuildContext context, WordHuntController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Hoàn thành! 🎉"),
        content: Text("Chúc mừng bạn đã hoàn thành tất cả câu hỏi!\nTổng điểm: ${controller.score}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.startGame(); // Reset
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

  // Dialog thua (Hết giờ)
  void _showLoseDialog(BuildContext context, WordHuntController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Thua cuộc! 😢"),
        content: const Text("Bạn đã hết thời gian!\nHãy thử lại nhé."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.startGame(); // Reset
            },
            child: const Text("Chơi lại ngay"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Exit
            },
            child: const Text("Thoát", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WordHuntController>();
    final question = controller.currentQuestion;

    // Lắng nghe sự kiện để hiện Dialog
    // Dùng addPostFrameCallback để tránh lỗi build khi hiện dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isGameOver && ModalRoute.of(context)?.isCurrent == true) {
        // Kiểm tra xem dialog đã hiện chưa để tránh hiện nhiều lần (đơn giản nhất là check mounted)
        // Nhưng tốt nhất controller nên có trạng thái để chặn gọi liên tục.
        // Ở đây ta giả định controller dừng timer rồi.
        _showLoseDialog(context, controller);
      } else if (question == null && !controller.isLoading && !controller.isGameOver && ModalRoute.of(context)?.isCurrent == true) {
        _showWinDialog(context, controller);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm từ nhanh"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.startGame,
          )
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.isGameOver 
              ? const SizedBox() // Khi thua thì hiện dialog, body trống hoặc chờ reset
              : question == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Score & Timer Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Điểm: ${controller.score}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${controller.timeLeft}s",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          
                          const SizedBox(height: 10),
                          // Progress Timer Bar
                          LinearProgressIndicator(
                            value: controller.timeLeft / 10,
                            backgroundColor: Colors.grey.shade200,
                            color: controller.timeLeft <= 3 ? Colors.red : Colors.orange,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          
                          const Spacer(flex: 1),
                          
                          // QUESTION CARD
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  question.icon,
                                  style: const TextStyle(fontSize: 60),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  question.question.toUpperCase(), // Nghĩa tiếng Việt
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Chọn từ tiếng Anh đúng",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Spacer(flex: 2),
                          
                          // OPTIONS GRID
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.5,
                            children: question.options.map((option) {
                              
                              // Determine color
                              Color btnColor = Colors.white;
                              Color textColor = Colors.black87;
                              
                              if (controller.isAnswered) {
                                if (option == question.correctAnswer) {
                                  btnColor = Colors.green;
                                  textColor = Colors.white;
                                } else if (option == controller.selectedAnswer) {
                                  btnColor = Colors.red;
                                  textColor = Colors.white;
                                }
                              }
                              
                              return ElevatedButton(
                                onPressed: () => controller.checkAnswer(option),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnColor,
                                  foregroundColor: textColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.grey.shade300, 
                                      width: 1
                                    ),
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
    );
  }
}
