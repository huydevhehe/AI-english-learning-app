import 'package:flutter/material.dart';

class TextInputBox extends StatelessWidget {
  final TextEditingController controller;

  const TextInputBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: _hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          height: 1.4,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

const String _hint = '''
Ví dụ:

1. Capital of France?
A. Berlin
B. Paris
C. Rome
D. Madrid
Answer: B
''';
