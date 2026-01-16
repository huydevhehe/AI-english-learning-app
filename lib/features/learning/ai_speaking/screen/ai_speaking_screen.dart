import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/ai_speaking_controller.dart';

class AiSpeakingScreen extends StatelessWidget {
  const AiSpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AiSpeakingController()..playSample(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FB),
        appBar: AppBar(
          title: const Text("Luyện nói – Level 1"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.deepPurple,
        ),
        body: Consumer<AiSpeakingController>(
          builder: (context, c, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== CÂU MẪU =====
                  Text(
                    "Nói theo câu ví dụ  này:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.withOpacity(0.15),
                          Colors.deepPurple.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      c.currentScript.sentence,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ===== MODE AI =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Chế độ AI:",
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          Text(
                            c.strictMode ? "Gắt 🤨" : "Dễ 😄",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Switch(
                            value: c.strictMode,
                            onChanged: (v) {
                              c.strictMode = v;
                              c.notifyListeners();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// ===== CÂU USER NÓI =====
                  if (c.lastUserText != null)
                    _bubble(
                      icon: Icons.record_voice_over,
                      color: Colors.blue,
                      text: 'M vừa nói: "${c.lastUserText}"',
                    ),

                  /// ===== AI ĐANG NGHĨ =====
                  if (c.isAiThinking)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text("AI đang nghe lại m nói…"),
                        ],
                      ),
                    ),

                  /// ===== FEEDBACK AI =====
                  if (c.feedback != null)
                    _bubble(
                      icon: Icons.smart_toy,
                      color: Colors.green,
                      text: c.feedback!,
                    ),

                  const Spacer(),

                  /// ===== BUTTON =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: "play",
                        backgroundColor: Colors.deepPurple.shade200,
                        onPressed: c.playSample,
                        child: const Icon(Icons.volume_up),
                      ),

                      FloatingActionButton(
                        heroTag: "mic",
                        backgroundColor:
                            c.isRecording ? Colors.red : Colors.deepPurple,
                        onPressed: c.startSpeaking,
                        child: Icon(
                          c.isRecording ? Icons.mic : Icons.mic_none,
                        ),
                      ),

                      FloatingActionButton(
                        heroTag: "next",
                        backgroundColor: Colors.deepPurple.shade200,
                        onPressed: c.next,
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bubble({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
