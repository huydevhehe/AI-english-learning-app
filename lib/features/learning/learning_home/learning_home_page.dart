import 'package:flutter/material.dart';
import 'topic_card.dart';
import '../vocabulary/vocab_page.dart';
import '../grammar_learn/screens/grammar_list_screen.dart';
import '../grammar_exercise/question_loader_page.dart';
import '../vocatopic/vocab_topics_page.dart';
import '../listening/listening_page.dart'; // nhớ đúng path

import '../reading/reading_hub_page.dart';
import '../ai_speaking/screen/ai_speaking_screen.dart';
import '../ai_assessment/screens/assessment_intro_screen.dart';

class LearningHomePage extends StatelessWidget {
  const LearningHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Các Bài Học Tiếng Anh  "),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AssessmentIntroScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.analytics,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "AI Skill Assessment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "AI Đánh giá trình độ \nPhân tích điểm yếu - Lộ trình học",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(235, 255, 255, 255),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiSpeakingScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF512DA8), Color(0xFF9575CD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.record_voice_over,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Luyện nói với AI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Nói chuyện trực tiếp\nAI nhận xét - sửa lỗi",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.80,
                children: [
                  // CARD 1 — Vocabulary
                  TopicCard(
                    icon: Icons.edit,
                    title: "Vocabulary",
                    subtitle: "Luyện từ vựng cơ bản",
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VocabularyPage(),
                        ),
                      );
                    },
                  ),

                  TopicCard(
                    icon: Icons.auto_stories,
                    title: "Vocabulary Topic",
                    subtitle: "Học từ theo từng chủ đề",
                    iconColor: Colors.deepOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VocabTopicsPage(),
                        ),
                      );
                    },
                  ),

                  // Grammar Exercise
                  TopicCard(
                    icon: Icons.book,
                    title: "Grammar Exercise",
                    subtitle: "Bài tập ngữ pháp",
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoriesScreen(),
                        ),
                      );
                    },
                  ),

                  TopicCard(
                    icon: Icons.menu_book,
                    title: "Grammar Learn",
                    subtitle: "Học lý thuyết ngữ pháp",
                    iconColor: Colors.lightGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GrammarListScreen(),
                        ),
                      );
                    },
                  ),

                  TopicCard(
                    icon: Icons.headphones,
                    title: "Listening",
                    subtitle: "Luyện nghe tiếng Anh",
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ListeningPage(),
                        ),
                      );
                    },
                  ),

                  TopicCard(
                    icon: Icons.menu_book,
                    title: "Reading",
                    subtitle: "Luyện đọc hiểu",
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReadingHubPage(),
                        ),
                      );
                    },
                  ),

                  // TopicCard(
                  //   icon: Icons.message,
                  //   title: "Idioms",
                  //   subtitle: "Thành ngữ thông dụng",
                  //   iconColor: Colors.purple,
                  //   onTap: () {},
                  // ),

                  // TopicCard(
                  //   icon: Icons.record_voice_over,
                  //   title: "Pronunciation",
                  //   subtitle: "Luyện phát âm",
                  //   iconColor: Colors.cyan,
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
