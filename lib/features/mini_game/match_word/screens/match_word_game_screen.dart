import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/match_word_controller.dart';

class MatchWordGameScreen extends StatelessWidget {
  const MatchWordGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatchWordController(),
      child: const _MatchWordGameView(),
    );
  }
}

class _MatchWordGameView extends StatelessWidget {
  const _MatchWordGameView();

  void _showWinDialog(BuildContext context, MatchWordController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Chúc mừng! 🎉"),
        content: Text("Bạn đã hoàn thành với số điểm: ${controller.score}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.startGame(); // Reset game
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
    final controller = context.watch<MatchWordController>();

    // Check game over
    if (controller.isGameCompleted() && !controller.isLoading) {
       // Dùng addPostFrameCallback để tránh lỗi build khi đang build
       WidgetsBinding.instance.addPostFrameCallback((_) {
         // Kiểm tra lại mounted để chắc chắn
         if (context.mounted && controller.isGameCompleted()) {
             _showWinDialog(context, controller);
         }
       });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghép từ vựng"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.startGame,
          )
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Score bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Điểm: ${controller.score}",
                          style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.green
                          ),
                        ),
                        Text(
                          "${controller.matchedLeft.length}/5",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Game Area
                  Expanded(
                    child: Row(
                      children: [
                        // Cột trái (Tiếng Việt)
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.leftSide.length,
                            itemBuilder: (context, index) {
                              final word = controller.leftSide[index];
                              
                              final isSelected = word == controller.selectedLeft;
                              final isMatched = controller.matchedLeft.contains(word);
                              
                              // Xác định màu sắc
                              Color bgColor = Colors.white;
                              Color borderColor = Colors.grey.shade300;
                              
                              if (isSelected) {
                                if (controller.currentStatus == MatchStatus.correct) {
                                  bgColor = Colors.green.shade100;
                                  borderColor = Colors.green;
                                } else if (controller.currentStatus == MatchStatus.wrong) {
                                  bgColor = Colors.red.shade100;
                                  borderColor = Colors.red;
                                } else {
                                  bgColor = Colors.orange.shade100;
                                  borderColor = Colors.orange;
                                }
                              }

                              return _buildCard(
                                word, 
                                isSelected, 
                                isMatched, 
                                bgColor,
                                borderColor,
                                () => controller.selectLeft(word)
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Cột phải (Tiếng Anh)
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.rightSide.length,
                            itemBuilder: (context, index) {
                              final word = controller.rightSide[index];
                              
                              final isSelected = word == controller.selectedRight;
                              final isMatched = controller.matchedRight.contains(word);
                              
                              // Xác định màu sắc
                              Color bgColor = Colors.white;
                              Color borderColor = Colors.grey.shade300;
                              
                              if (isSelected) {
                                if (controller.currentStatus == MatchStatus.correct) {
                                  bgColor = Colors.green.shade100;
                                  borderColor = Colors.green;
                                } else if (controller.currentStatus == MatchStatus.wrong) {
                                  bgColor = Colors.red.shade100;
                                  borderColor = Colors.red;
                                } else {
                                  bgColor = Colors.orange.shade100;
                                  borderColor = Colors.orange;
                                }
                              }
                              
                              return _buildCard(
                                word, 
                                isSelected, 
                                isMatched, 
                                bgColor,
                                borderColor,
                                () => controller.selectRight(word)
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(
    String text, 
    bool isSelected, 
    bool isMatched, 
    Color bgColor,
    Color borderColor,
    VoidCallback onTap
  ) {
    if (isMatched) {
      return Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
          color: Colors.transparent, // Ẩn hoàn toàn
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black87 : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
