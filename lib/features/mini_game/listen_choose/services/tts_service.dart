import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4);   // chậm hơn, rõ
    await _tts.setPitch(1.0);        // giọng tự nhiên
    await _tts.setVolume(1.0);

    _initialized = true;
  }

  Future<void> speak(String text) async {
    await _init();
    await _tts.stop();               // ⛔ tránh đớt đớt
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
