import 'package:flutter/material.dart';
import '../service/ai_chat_service.dart';

class ChatController extends ChangeNotifier {
  final AiChatService _service = AiChatService();

  final List<String> messages = [];
  bool isLoading = false;

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;

    messages.add("🧑 $text");
    isLoading = true;
    notifyListeners();

    try {
      final reply = await _service.sendMessage(text);
      messages.add("🤖 $reply");
    } catch (e) {
      messages.add("⚠️ Lỗi: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
  