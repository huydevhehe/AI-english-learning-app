import 'dart:async';
import 'package:flutter/material.dart';

import '../service/tts_service.dart';
import '../service/speech_to_text_service.dart';
import '../../../chatbox/service/ai_chat_service.dart';
import '../data/speaking_level1_scripts.dart';

class AiSpeakingController extends ChangeNotifier {
  final tts = TtsService();
  final speech = SpeechToTextService(); // GOOGLE STT
  final ai = AiChatService();

  int currentIndex = 0;
  bool isRecording = false;
  bool isAiThinking = false;
 bool strictMode = false;  
  String? feedback;
  String? lastUserText;

  SpeakingScript get currentScript => level1Scripts[currentIndex];

  void playSample() {
    tts.speak(currentScript.sentence);
  }
String easyPersonaPrompt = '''
Mày là bạn thân của người học.
- Nói nhẹ nhàng, khuyến khích
- Sai thì góp ý lịch sự
- Không chửi, không mỉa
- Nói như người bình thường
- so sánh với câu mẫu đừng cho nói câu ngoài lề 
''';

String hardPersonaPrompt = '''
Mày là giáo viên KHÓ TÍNH, miệng mồm gắt gỏng, nói chuyện như ngoài đời.
- ĐƯỢC chửi thề, nói tục thoải mái hạn chế từ đéo cút
- So sáng dựa theo câu mẫu nói khác hoặc ngoài lề là sai 
- ĐƯỢC chọc quê, cười khẩy, mỉa mai
- Sai là nói thẳng, không nịnh
- ĐƯỢC phạt nói lại
- Nói ngắn, gắt, có nhịp điệu như người thật
- KHÔNG cần lịch sự
- Nếu đọc sai áp dụng hình phạt thật nặng cực nặng 

NGUYÊN TẮC NÓI CHUYỆN:
- Nói như người thật ngoài đời, không phải robot.
- KHÔNG được dùng các từ: "hình phạt", "phạt", "luật", "quy định".
- KHÔNG được trình bày dạng thông báo hay gạch đầu dòng.
- KHÔNG được dùng markdown, dấu **, hay tiêu đề.
- không cần ghi về phạt ghi thẳng hình phạt ra là được 

''';

  ///  BẤM MIC → GOOGLE POPUP → NHẬN TEXT
  Future<void> startSpeaking() async {
    if (isRecording) return;

    isRecording = true;
    feedback = "🎙️ Nói đi...";
    notifyListeners();

    final userText = await speech.listen();

    isRecording = false;
    notifyListeners();

    if (userText == null || userText.trim().isEmpty) {
      feedback = "😅 Tao chưa nghe rõ, mài nói lại nha";
      notifyListeners();
      await tts.speak(feedback!);
      return;
    }

    //  GIỮ LẠI CÂU USER NÓI
    lastUserText = userText.trim();
    notifyListeners();

    //  TRẠNG THÁI AI ĐANG CHẤM
    isAiThinking = true;
    notifyListeners();

   final reply = strictMode
    ? await ai.sendMessage('''
$hardPersonaPrompt

Câu chuẩn:
"${currentScript.sentence}"

Người học nói:
"$lastUserText"

NHIỆM VỤ:
- So sánh nghiêm khắc
- Sai là nói thẳng, gắt
- Đúng thì công nhận ngắn gọn

YÊU CẦU:
- Tối đa 5 câu
- Giọng gắt
- Tiếng Việt
''')
    : await ai.sendMessage('''
$easyPersonaPrompt

Câu chuẩn:
"${currentScript.sentence}"

Người học nói:
"$lastUserText"

NHIỆM VỤ:
- So sánh nhẹ nhàng
- Sai thì góp ý
- Đúng thì khen

YÊU CẦU:
- 3–4 câu
- Giọng thân thiện
- Tiếng Việt
''');


    isAiThinking = false;
    feedback = reply.trim();
    notifyListeners();

    //  Delay nhẹ cho UI mượt
    await Future.delayed(const Duration(milliseconds: 300));

    await tts.speak(
  feedback!,
  strictMode: strictMode,
);

  }

  void next() {
    if (currentIndex < level1Scripts.length - 1) {
      currentIndex++;
      feedback = null;
      lastUserText = null;
      notifyListeners();
      playSample();
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }
}
String normalizeSentence(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
