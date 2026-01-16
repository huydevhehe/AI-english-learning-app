import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/chat_controller.dart';
import '../widget/chat_input.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ChatController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Trợ lý AI")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ctrl.messages.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(ctrl.messages[i]),
              ),
            ),
          ),
          if (ctrl.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ChatInput(
              onSend: ctrl.send,
            ),
          ),
        ],
      ),
    );
  }
}
