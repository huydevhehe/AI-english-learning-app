import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/ai_assessment_controller.dart';

class AssessmentResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int timeSpentSeconds;
  final Map<String, dynamic> skills;
  final List<String> wrongQuestionTypes;

  const AssessmentResultScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeSpentSeconds,
    required this.skills,
    required this.wrongQuestionTypes,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AiAssessmentController()
        ..submitTest(
          totalQuestions: totalQuestions,
          correctAnswers: correctAnswers,
          timeSpentSeconds: timeSpentSeconds,
          skills: skills,
          wrongQuestionTypes: wrongQuestionTypes,
        ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5FB),
        appBar: AppBar(
          title: const Text("Kết quả đánh giá"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<AiAssessmentController>(
          builder: (context, ctrl, _) {
            if (ctrl.isLoading) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text("AI đang phân tích kết quả..."),
                  ],
                ),
              );
            }

            final r = ctrl.result;
            if (r == null) {
              return const Center(child: Text("Không có kết quả đánh giá"));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// ===== LEVEL BADGE =====
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Trình độ hiện tại",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        r.overallLevel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$correctAnswers / $totalQuestions câu đúng",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== SUMMARY =====
                _InfoCard(
                  title: "Nhận xét tổng quan",
                  icon: Icons.insights,
                  child: Text(
                    r.summary,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 16),

                /// ===== WEAKNESSES =====
                _InfoCard(
                  title: "Điểm yếu cần cải thiện",
                  icon: Icons.warning_amber_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.weaknesses
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(e)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 16),

                /// ===== ROADMAP =====
                _InfoCard(
                  title: "Lộ trình học đề xuất",
                  icon: Icons.route,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.learningRoadmap.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final text = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.deepPurple,
                              child: Text(
                                index.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(text)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                /// ===== DONE BUTTON =====
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Hoàn tất",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                         color: Colors.white, 
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ===== REUSABLE CARD =====
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
