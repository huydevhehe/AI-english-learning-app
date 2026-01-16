import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  /// Init 1 lần
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

   await _tts.setSpeechRate(0.25);
await _tts.setPitch(1.0);

    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
     // 🔍 LOG TẤT CẢ VOICE
  final voices = await _tts.getVoices;
  print("TTS VOICES = $voices");
  }

  /// Hàm chính để đọc
 Future<void> speak(String text, {bool strictMode = false}) async {
  await init();

  final isEnglish = _isEnglish(text);

  if (isEnglish) {
    await _tts.setLanguage("en-US");
  } else {
    await _tts.setLanguage("vi-VN");
  }

  // ===== GIỌNG ĐIỆU =====
  if (strictMode) {
    // 🔥 GẮT
    await _tts.setSpeechRate(0.68); // chậm hơn chút
await _tts.setPitch(0.9);      // vẫn trầm, không robot

  } else {
    // 😄 DỄ
    await _tts.setSpeechRate(0.6);
    await _tts.setPitch(1.0);
  }

  await _tts.stop();

  final cleaned = _cleanForTts(
    _humanize(text, isEnglish: isEnglish),
  );

  // ===== ĐỌC THEO NHỊP (QUAN TRỌNG) =====
  if (strictMode) {
    final parts = cleaned.split(RegExp(r'[,.]'));
    for (final p in parts) {
      final s = p.trim();
      if (s.isEmpty) continue;

      await _tts.speak(s);
      await Future.delayed(const Duration(milliseconds: 120));
    }
  } else {
    await _tts.speak(cleaned);
  }
}


  /// Detect đơn giản: có nhiều chữ cái + ít dấu tiếng Việt → English
  bool _isEnglish(String text) {
    final lower = text.toLowerCase();

    // Nếu có dấu tiếng Việt → chắc chắn là VI
    final vietnameseChars = RegExp(r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]');
    if (vietnameseChars.hasMatch(lower)) return false;

    // Có nhiều chữ cái a-z → EN
    final letters = RegExp(r'[a-z]');
    final matches = letters.allMatches(lower).length;

    return matches >= 3;
  }

  /// Làm câu nghe tự nhiên hơn (chỉ áp cho TIẾNG VIỆT)
  String _humanize(String text, {required bool isEnglish}) {
    if (isEnglish) {
      // ❌ KHÔNG thêm “Ừm…” vào tiếng Anh
      return text.trim();
    }

    return text
        .replaceAll('\n', ' ')
        .replaceAll('.', '. ')
        .replaceAll(':', ', ')
        .replaceAll('!', ' !')
        .replaceAll('?', ' ?')
        .trim()
        .replaceFirstMapped(
          RegExp(r'^'),
          (m) => '… ',
        );
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
String _cleanForTts(String text) {
  return text
      .replaceAll(RegExp(r'[*#_~`>|]'), '')
      .replaceAll(RegExp(r'\[(.*?)\]'), '')
      .replaceAll(RegExp(r'\((.*?)\)'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
