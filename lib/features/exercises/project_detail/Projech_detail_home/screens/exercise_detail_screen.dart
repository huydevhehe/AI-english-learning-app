import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/question_play_card.dart';
import '../widgets/result_view.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String projectId;
  final String exerciseId;

  const ExerciseDetailScreen({
    super.key,
    required this.projectId,
    required this.exerciseId,
  });

  @override
  State<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState
    extends State<ExerciseDetailScreen> {
  int _currentIndex = 0;
  bool _isFinished = false;
  bool _showAnswer = false;

  /// key = questionIndex, value = selected option index
  final Map<int, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    final exercisesRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('exercises');

    final aiQuizRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('ai_quizzes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Làm bài trắc nghiệm'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 1️⃣ thử load manual quiz trước
        stream: exercisesRef
            .where(FieldPath.documentId,
                isEqualTo: widget.exerciseId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ===== KHÔNG CÓ TRONG EXERCISES → THỬ AI QUIZ =====
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return StreamBuilder<DocumentSnapshot>(
              stream:
                  aiQuizRef.doc(widget.exerciseId).snapshots(),
              builder: (context, aiSnapshot) {
                if (aiSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!aiSnapshot.hasData ||
                    !aiSnapshot.data!.exists) {
                  return const Center(
                    child: Text('Bài tập không tồn tại'),
                  );
                }

                final data = aiSnapshot.data!.data()
                    as Map<String, dynamic>;

                return _buildQuizBody(
                  data,
                  isAiQuiz: true,
                );
              },
            );
          }

          // ===== MANUAL QUIZ =====
          final data = snapshot.data!.docs.first.data()
              as Map<String, dynamic>;

          return _buildQuizBody(
            data,
            isAiQuiz: false,
          );
        },
      ),
    );
  }

  /// ================== GIỮ NGUYÊN LOGIC CŨ – CHỈ TÁCH RA ==================
  Widget _buildQuizBody(
    Map<String, dynamic> data, {
    required bool isAiQuiz,
  }) {
    final List<Map<String, dynamic>> questions =
        List<Map<String, dynamic>>.from(
      data['questions'] ?? [],
    );

    if (questions.isEmpty) {
      return const Center(
        child: Text('Bài tập chưa có câu hỏi'),
      );
    }

    // ================= KHI ĐÃ LÀM XONG =================
    if (_isFinished) {
      return ResultView(
        questions: questions,
        answers: _answers,
      );
    }

    final currentQuestion = questions[_currentIndex];

    /// ✅ OPTIONS
    final List<String> options = isAiQuiz
        ? List<String>.from(
            currentQuestion['options']
                .map((o) => o['text']),
          )
        : List<String>.from(currentQuestion['options']);

    /// ✅ CORRECT INDEX
    final int correctIndex = isAiQuiz
        ? currentQuestion['options'].indexWhere(
            (o) =>
                o['key'] ==
                currentQuestion['correctAnswer'],
          )
        : currentQuestion['correctIndex'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ================= PROGRESS =================
          Text(
            'Câu ${_currentIndex + 1} / ${questions.length}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: QuestionPlayCard(
              question: currentQuestion['question'],
              options: options,
              selectedIndex: _answers[_currentIndex],
              correctIndex: correctIndex,
              showAnswer: _showAnswer,
              onSelect: (selected) {
                if (_showAnswer) return;

                setState(() {
                  _answers[_currentIndex] = selected;
                  _showAnswer = true;
                });

                Future.delayed(const Duration(seconds: 2),
                    () {
                  if (!mounted) return;

                  setState(() {
                    _showAnswer = false;

                    if (_currentIndex <
                        questions.length - 1) {
                      _currentIndex++;
                    } else {
                      _isFinished = true;
                    }
                  });
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // ================= NEXT / SUBMIT =================
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed:
                  _answers.containsKey(_currentIndex)
                      ? () {
                          if (_currentIndex <
                              questions.length - 1) {
                            setState(() {
                              _currentIndex++;
                            });
                          } else {
                            setState(() {
                              _isFinished = true;
                            });
                          }
                        }
                      : null,
              child: Text(
                _currentIndex ==
                        questions.length - 1
                    ? 'Nộp bài'
                    : 'Câu tiếp theo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
