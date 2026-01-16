import 'package:flutter/material.dart';
import '../../features/chatbox/screen/chat_screen.dart';

class GlobalChatButton extends StatelessWidget {
  final Widget child;

  const GlobalChatButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            child: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
