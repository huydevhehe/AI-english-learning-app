import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiChatService {
  static String get _endpoint {
   
    if (kReleaseMode) {
      return "https://us-central1-my-app-english-c87dd.cloudfunctions.net/chatBeargoAI";
    }


    return "http://127.0.0.1:5001/my-app-english-c87dd/us-central1/chatBeargoAI";
  }

  Future<String> sendMessage(String message) async {
    final res = await http.post(
      Uri.parse(_endpoint),
      headers: const {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": message,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("API lỗi ${res.statusCode}: ${res.body}");
    }

    final data = jsonDecode(res.body);
    return data["answer"];
  }
}
