import 'package:flutter/material.dart';
import 'vocab_topic_question_model.dart';
import 'vocab_topic_service.dart';
import '../../../core/utils/sound_effect.dart';

class VocabQuizPage extends StatefulWidget {
  final String topicId;

  const VocabQuizPage({super.key, required this.topicId});

  @override
  State<VocabQuizPage> createState() => _VocabQuizPageState();
}

class _VocabQuizPageState extends State<VocabQuizPage>
    with SingleTickerProviderStateMixin {
late List<VocabTopicQuestion> questions;  bool loading = true;
  int currentIndex = 0;
  bool answered = false;
  int? selectedAnswer;

  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();
 _loadQuestions(); // ✅ gọi async loader
    shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    shakeAnimation = Tween<double>(begin: 0, end: 12)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(shakeController);
  }
Future<void> _loadQuestions() async {
  final service = VocabTopicService();
  final data = await service.fetchQuestions(widget.topicId);

  if (!mounted) return;

  setState(() {
    questions = data;
     loading = false;
  });
}

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }

  void checkAnswer(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedAnswer = index;
    });

    final correct = questions[currentIndex].correct;
if (index == correct) {
  SoundEffect.playCorrect(); // ✅ đúng → random sound đúng
} else {
  SoundEffect.playWrong();   // ❌ sai → random sound sai
}

    if (index != correct) {
      shakeController.forward(from: 0);
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedAnswer = null;
        });
      } else {
        _showFinishDialog();
      }
    });
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hoàn thành!"),
        content: const Text("Bạn đã hoàn tất bài luyện tập."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
  // ⛔ CHẶN BUILD KHI CHƯA LOAD
  if (loading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  if (questions.isEmpty) {
    return const Scaffold(
      body: Center(child: Text("Chưa có câu hỏi")),
    );
  }

  // ✅ ĐẶT Ở ĐÂY
  final q = questions[currentIndex];
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Luyện từ vựng"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              q.icon ?? "❓",
              style: const TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 12),

            Text(
              "Câu ${currentIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Text(
    q.question,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
  ),
),


            const SizedBox(height: 20),

            Expanded(
              child: AnimatedBuilder(
                animation: shakeAnimation,
                builder: (_, child) {
                  final dx = answered && selectedAnswer != q.correct
                      ? shakeAnimation.value
                      : 0.0;

                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: child,
                  );
                },
                child: ListView.builder(
                  itemCount: q.answers.length,
                  itemBuilder: (_, i) {
                    final isCorrect = answered && i == q.correct;
                    final isWrong = answered && i == selectedAnswer && i != q.correct;

                    return GestureDetector(
                      onTap: () => checkAnswer(i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(16),
  color: isCorrect
      ? Colors.green.withOpacity(0.15)
      : isWrong
          ? Colors.red.withOpacity(0.15)
          : Theme.of(context).cardColor,
  border: Border.all(
    color: isCorrect
        ? Colors.green
        : isWrong
            ? Colors.red
            : Theme.of(context).dividerColor,
    width: 2,
  ),
  boxShadow: [
    if (!answered)
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
  ],
),

                        child: Text(
  q.answers[i],
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
),

                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
