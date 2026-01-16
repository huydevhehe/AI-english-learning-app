import 'package:flutter/services.dart';

class SpeechToTextService {
  static const MethodChannel _channel =
      MethodChannel('beargo/speech');

  Future<String?> listen() async {
    try {
      final text = await _channel.invokeMethod<String>('startSpeech');
      return text;
    } catch (e) {
      return null;
    }
  }
}
