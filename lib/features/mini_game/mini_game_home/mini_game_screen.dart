import 'package:flutter/material.dart';
import 'widgets/game_card.dart';
import '../match_word/screens/match_word_game_screen.dart';
import '../memory_card/screens/memory_card_game_screen.dart';
import '../guess_word/screens/guess_screen.dart';
import '../scramble_word/screens/scramble_screen.dart';
import '../quiz/quiz_page.dart';
import '../listen_choose/screens/listen_screen.dart';
import '../word_hunt/screens/word_hunt_game_screen.dart';
import '../fill_in_blank/screens/fill_in_blank_game_screen.dart';
class MiniGameScreen extends StatelessWidget {
  const MiniGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // 🎮 HEADER MINI GAMES
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.videogame_asset, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Mini Games",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Học mà chơi, chơi mà học!",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // 🎲 GRID GAME
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                GameCard(
                  title: "Ghép từ",
                  subtitle: "Ghép từ đúng",
                  icon: Icons.extension,
                  colors: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MatchWordGameScreen()),
                    );
                  },
                ),

                GameCard(
                  title: "Trí nhớ",
                  subtitle: "Lật thẻ ghi nhớ",
                  icon: Icons.psychology,
                  colors: const [Color(0xFFFFB74D), Color(0xFFF57C00)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MemoryCardGameScreen()),
                    );
                  },
                ),
                GameCard(
                  title: "Xếp chữ",
                  subtitle: "Sắp xếp chữ cái",
                  icon: Icons.sort_by_alpha,
                  colors: const [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScrambleScreen(
                          topic: "animal", // hoặc topic m muốn
                        ),
                      ),
                    );
                  },
                ),

                GameCard(
                  title: "Đoán từ",
                  subtitle: "Chọn đáp án",
                  icon: Icons.help_outline,
                  colors: const [Color(0xFFAB47BC), Color(0xFF8E24AA)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GuessScreen(
                          topic: "animal", // hoặc topic m muốn
                        ),
                      ),
                    );
                  },
                ),

                GameCard(
                  title: "Nghe & Chọn",
                  subtitle: "Nghe và phản xạ",
                  icon: Icons.headphones,
                  colors: const [Color(0xFF26C6DA), Color(0xFF0097A7)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ListenScreen()),
                    );
                  },
                ),

                GameCard(
  title: "Word Hunt",
  subtitle: "Tìm từ nhanh",
  icon: Icons.search,
  colors: const [
    Color(0xFF7E57C2),
    Color(0xFF5E35B1),
  ],
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WordHuntGameScreen(),
      ),
    );
  },
),

                GameCard(
  title: "Điền từ",
  subtitle: "Hoàn thành câu",
  icon: Icons.edit,
  colors: const [
    Color(0xFF9CCC65),
    Color(0xFF7CB342),
  ],
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FillInBlankGameScreen(),
      ),
    );
  },
),

                GameCard(
                  title: "Speed Quiz",
                  subtitle: "Phản xạ nhanh",
                  icon: Icons.flash_on,
                  colors: const [Color(0xFFEF5350), Color(0xFFE53935)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
