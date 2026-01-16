import 'package:flutter/material.dart';
import '../services/assessment_test_service.dart';
import '../models/assessment_question.dart';
import 'assessment_result_screen.dart';

class AssessmentTestScreen extends StatefulWidget {
  const AssessmentTestScreen({super.key});

  @override
  State<AssessmentTestScreen> createState() => _AssessmentTestScreenState();
}

class _AssessmentTestScreenState extends State<AssessmentTestScreen> {
  final AssessmentTestService _service = AssessmentTestService();

  List<AssessmentQuestion> _questions = [];
  int _currentIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    try {
      final data = await _service.loadTest();
      setState(() {
        _questions = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _submitTest() {
    int correct = 0;

    final Map<String, Map<String, int>> skills = {
      "grammar": {"correct": 0, "total": 0},
      "vocabulary": {"correct": 0, "total": 0},
      "reading": {"correct": 0, "total": 0},
    };

    for (final q in _questions) {
      if (!skills.containsKey(q.skill)) continue;
      skills[q.skill]!["total"] = skills[q.skill]!["total"]! + 1;

      if (q.userAnswer == q.correctAnswer) {
        correct++;
        skills[q.skill]!["correct"] = skills[q.skill]!["correct"]! + 1;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AssessmentResultScreen(
          totalQuestions: _questions.length,
          correctAnswers: correct,
          timeSpentSeconds: 600,
          skills: skills,
          wrongQuestionTypes: const [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Không tải được bài đánh giá")),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FB),
      appBar: AppBar(
        title: const Text("AI Skill Assessment"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Progress
            Text(
              "Câu ${_currentIndex + 1} / ${_questions.length}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.deepPurple.shade100,
                valueColor:
                    const AlwaysStoppedAnimation(Colors.deepPurple),
              ),
            ),

            const SizedBox(height: 20),

            /// Question Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Text(
                question.question,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Options
            ...question.options.map((option) {
              final value = option['key']?.toString() ?? "";
              final text = option['text']?.toString() ?? "";
              final selected = question.userAnswer == value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    question.userAnswer = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.deepPurple.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selected
                            ? Colors.deepPurple
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            /// Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (_currentIndex == _questions.length - 1) {
                    _submitTest();
                  } else {
                    setState(() => _currentIndex++);
                  }
                },
                child: Text(
                  _currentIndex == _questions.length - 1
                      ? "Nộp bài"
                      : "Tiếp tục",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                     color: Colors.white, 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
