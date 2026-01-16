import 'package:flutter/material.dart';

import '../../manual_create/screens/create_manual_screen.dart';
import '../services/mcq_parser.dart';

class DocumentTextInputScreen extends StatefulWidget {
  final String projectId;

  const DocumentTextInputScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<DocumentTextInputScreen> createState() =>
      _DocumentTextInputScreenState();
}

class _DocumentTextInputScreenState
    extends State<DocumentTextInputScreen> {
  final _textCtrl = TextEditingController();
  String? _error;

  void _analyze() {
    final raw = _textCtrl.text.trim();

    if (raw.isEmpty) {
      setState(() {
        _error = 'Vui lòng dán nội dung trắc nghiệm';
      });
      return;
    }

    final questions = McqParser.parse(raw);

    if (questions.isEmpty) {
      setState(() {
        _error =
            'Không tìm thấy câu trắc nghiệm hợp lệ.\n'
            'Vui lòng kiểm tra lại định dạng.';
      });
      return;
    }

    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CreateManualScreen(
      projectId: widget.projectId,
      initialQuestions: questions, // ✅ ĐÚNG
    ),
  ),
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập trắc nghiệm từ văn bản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textCtrl,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText:
                      'Ví dụ:\n\n'
                      'Câu 1: Thủ đô của Pháp là gì?\n'
                      'A. Berlin\n'
                      'B. Madrid\n'
                      'C. Paris\n'
                      'D. Rome\n'
                      'Đáp án: C',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _analyze,
                child: const Text('Phân tích'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
