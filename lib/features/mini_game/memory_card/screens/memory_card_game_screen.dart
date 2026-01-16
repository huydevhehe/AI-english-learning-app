import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/memory_card_controller.dart';
import '../models/memory_card_model.dart';

class MemoryCardGameScreen extends StatelessWidget {
  const MemoryCardGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryCardController(),
      child: const _MemoryCardGameView(),
    );
  }
}

class _MemoryCardGameView extends StatelessWidget {
  const _MemoryCardGameView();

  void _showWinDialog(BuildContext context, MemoryCardController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Xuất sắc! 🧠"),
        content: Text("Bạn đã hoàn thành trong ${controller.moves} lượt lật."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.startGame(); // Chơi lại
            },
            child: const Text("Chơi lại"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Thoát
            },
            child: const Text("Thoát"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MemoryCardController>();

    // Check completion
    if (controller.isGameCompleted()) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         _showWinDialog(context, controller);
       });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trí nhớ siêu phàm"),
        backgroundColor: Colors.orange,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Lượt: ${controller.moves}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Điểm: ${controller.score}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: controller.cards.length,
                      itemBuilder: (context, index) {
                        final card = controller.cards[index];
                        return _buildCard(card, () => controller.onCardTap(card));
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(MemoryCardItem card, VoidCallback onTap) {
    // Check nếu text là Emoji (độ dài ngắn và không phải chữ cái a-z thông thường)
    // Cách đơn giản: Nếu độ dài <= 4 ký tự thì khả năng cao là Icon hoặc từ rất ngắn => Font to
    // Nếu dài hơn thì font nhỏ
    final bool isLikelyEmoji = card.text.runes.length <= 2;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched 
              ? Colors.white 
              : Colors.orange,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.shade800,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            )
          ],
        ),
        alignment: Alignment.center,
        child: card.isFlipped || card.isMatched
            ? Text(
                card.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isLikelyEmoji ? 32 : 16, // Font to cho Emoji
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
              )
            : const Icon(
                Icons.question_mark,
                color: Colors.white,
                size: 32,
              ),
      ),
    );
  }
}
