import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'vocab_controller.dart';
import '../../../core/utils/sound_effect.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage>
    with SingleTickerProviderStateMixin {
  final controller = VocabController();

  bool answered = false;
  int? selectedIndex;

  late AnimationController shakeController;
  late Animation<double> shakeAnim;

  @override
  void initState() {
    super.initState();

    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    shakeAnim = Tween<double>(
      begin: 0,
      end: 18,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(shakeController);
  }

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = controller.currentQuestion;

    return Scaffold(
      appBar: AppBar(title: const Text("Vocabulary Practice"), elevation: 0),

      body: Column(
        children: [
          // PROGRESS BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: LinearProgressIndicator(
              value: (controller.index + 1) / controller.total(),
              backgroundColor: Theme.of(context).dividerColor,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),

              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // QUESTION + OPTIONAL IMAGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    q.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (q.animation != null)
                  SizedBox(
                    height: 190,
                    child: Lottie.asset(q.animation!, fit: BoxFit.contain),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: q.answers.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, i) {
                final isCorrect = (q.correct == i);
                final isSelected = (selectedIndex == i);

                Color bg = Theme.of(context).cardColor;
                Color border = Theme.of(context).dividerColor.withOpacity(0.2);

                if (answered) {
                  if (isCorrect) {
                    bg = Colors.green.shade100;
                    border = Colors.green;
                  } else if (isSelected) {
                    bg = Colors.red.shade100;
                    border = Colors.red;
                  }
                }

                return AnimatedBuilder(
                  animation: shakeController,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: Offset(
                        (answered && isSelected && !isCorrect)
                            ? shakeAnim.value
                            : 0,
                        answered && isCorrect ? -6 : 0, // bounce
                      ),
                      child: Transform.scale(
                        scale: answered && isCorrect ? 1.05 : 1.0,
                        child: GestureDetector(
                          onTap: answered ? null : () => handleAnswer(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: border, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                                if (answered && isCorrect)
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.35),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                if (answered && isCorrect)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 26,
                                  ),

                                if (answered && isSelected && !isCorrect)
                                  const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 26,
                                  ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    q.answers[i],
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void handleAnswer(int index) async {
    setState(() {
      selectedIndex = index;
      answered = true;
    });

    bool correct = controller.answer(index);
if (correct) {
  SoundEffect.playCorrect(); // ✅ âm thanh đúng (random)
} else {
  SoundEffect.playWrong(); // ❌ âm thanh sai (random)
}

    if (!correct) {
      shakeController.forward(from: 0);
    }

    await Future.delayed(const Duration(seconds: 2));

    if (controller.next()) {
      setState(() {
        answered = false;
        selectedIndex = null;
      });
    } else {
      showFinishDialog();
    }
  }

  void showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Hoàn thành!"),
        content: Text(
          "Điểm của bạn: ${controller.score} / ${controller.total()}",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Quay lại"),
          ),
        ],
      ),
    );
  }
}
