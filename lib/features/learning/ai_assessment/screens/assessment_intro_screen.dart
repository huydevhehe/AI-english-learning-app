import 'package:flutter/material.dart';
import 'assessment_test_screen.dart';

class AssessmentIntroScreen extends StatelessWidget {
  const AssessmentIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FB),
      appBar: AppBar(
        title: const Text("AI Skill Assessment"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// ===== HERO CARD =====
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7C4DFF),
                    Color(0xFF9575CD),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.psychology_alt_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Đánh giá năng lực\nTiếng Anh bằng AI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "AI sẽ phân tích trình độ hiện tại,\nchỉ ra điểm yếu và đề xuất lộ trình học phù hợp cho bạn.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ===== BENEFITS =====
            _BenefitItem(
              icon: Icons.bar_chart_rounded,
              title: "Xác định trình độ",
              subtitle: "Đánh giá theo chuẩn A1 – C1",
            ),
            const SizedBox(height: 12),
            _BenefitItem(
              icon: Icons.warning_amber_rounded,
              title: "Phân tích điểm yếu",
              subtitle: "Grammar, Vocabulary, Reading",
            ),
            const SizedBox(height: 12),
            _BenefitItem(
              icon: Icons.route_rounded,
              title: "Lộ trình cá nhân hóa",
              subtitle: "Biết rõ cần học gì tiếp theo",
            ),

            const Spacer(),

            /// ===== START BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AssessmentTestScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Bắt đầu tạo bài test",
                  style: TextStyle(
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

/// ===== BENEFIT ITEM =====
class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
