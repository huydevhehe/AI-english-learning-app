import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'listening_controller.dart';
import 'listening_choice_widget.dart';
import 'listening_input_widget.dart';
import '../../../core/utils/sound_effect.dart';

class ListeningPage extends StatelessWidget {
  const ListeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListeningController()..loadQuestions(),
      child: const _ListeningView(),
    );
  }
}

class _ListeningView extends StatefulWidget {
  const _ListeningView();

  @override
  State<_ListeningView> createState() => _ListeningViewState();
}

class _ListeningViewState extends State<_ListeningView> {
  final FlutterTts _tts = FlutterTts();

  int _score = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.45);
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ListeningController>();
    final question = controller.currentQuestion;

    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// KẾT THÚC BÀI
    if (_finished) {
      final percent = ((_score / controller.total) * 100).round();

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Listening Result"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎉 Hoàn thành!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text("Điểm của bạn", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                "$_score / ${controller.total}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text("$percent%", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Quay lại"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Listening")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Center(
              child: Column(
                children: [
Text(
  "🎧",
  style: TextStyle(
    fontSize: 48,
    color: Theme.of(context).colorScheme.primary,
  ),
),
                  const SizedBox(height: 6),
                  Text(
                    "Câu ${controller.currentIndex + 1}/${controller.total}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// NÚT NGHE
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _speak(question.fullSentence);
                },
                icon: const Icon(Icons.volume_up),
                label: const Text("Nghe"),
              ),
            ),

            const SizedBox(height: 24),

            /// CÂU HỎI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                controller.displaySentence,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 24),

            /// KHU TRẢ LỜI
            if (controller.isCorrect == null)
              controller.mode == ListeningMode.choice
                  ? ListeningChoiceWidget(
                      options: question.options,
                      onSelect: (answer) {
                        controller.submitAnswer(answer);
                        if (controller.isCorrect == true) {
                          _score++;
                        }
                      },
                    )
                  : ListeningInputWidget(
                      onSubmit: (answer) {
                        controller.submitAnswer(answer);
                        if (controller.isCorrect == true) {
                          _score++;
                        }
                      },
                    )
            else
              _ResultCard(
                isCorrect: controller.isCorrect!,
                correctAnswer: question.missingWord,
                onNext: () {
                  if (controller.currentIndex == controller.total - 1) {
                    setState(() {
                      _finished = true;
                    });
                  } else {
                    controller.nextQuestion();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onNext;

  const _ResultCard({
    required this.isCorrect,
    required this.correctAnswer,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isCorrect) {
        SoundEffect.playCorrect();
      } else {
        SoundEffect.playWrong();
      }
    });

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCorrect
                ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                : Theme.of(context).colorScheme.error.withOpacity(0.15),

            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                isCorrect ? "✅ ĐÚNG" : "❌ SAI",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isCorrect
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 8),
                Text(
                  "Đáp án đúng: $correctAnswer",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onNext,
            child: const Text("Tiếp tục"),
          ),
        ),
      ],
    );
  }
}
