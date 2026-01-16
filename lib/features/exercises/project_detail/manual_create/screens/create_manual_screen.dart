import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mcq_question_form.dart';
import '../widgets/question_card.dart';

class CreateManualScreen extends StatefulWidget {
  final String projectId;
 final bool isAiQuiz; // ✅ BẮT BUỘC
  // ===== THÊM ĐỂ HỖ TRỢ SỬA =====
  final String? exerciseId;
  final Map<String, dynamic>? initialData;
    final List<McqQuestionForm>? initialQuestions;
  const CreateManualScreen({
    super.key,
    required this.projectId,
    this.exerciseId,
    this.initialData,
     this.initialQuestions,
      this.isAiQuiz = false, // ✅ THÊM
  });

  bool get isEdit => exerciseId != null;

  @override
  State<CreateManualScreen> createState() => _CreateManualScreenState();
}

class _CreateManualScreenState extends State<CreateManualScreen> {
  final _exerciseTitleCtrl = TextEditingController();
  final List<McqQuestionForm> _questions = [];

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initOnce();
  }

  void _initOnce() {
  if (_initialized) return;
  _initialized = true;

  // ===== ƯU TIÊN DATA ĐƯỢC ĐỔ TỪ TEXT / AI =====
  if (widget.initialQuestions != null &&
      widget.initialQuestions!.isNotEmpty) {
    _questions.clear();
    _questions.addAll(widget.initialQuestions!);
    return;
  }

  // ===== EDIT MODE (DATA TỪ FIRESTORE) =====
  if (widget.isEdit && widget.initialData != null) {
    _exerciseTitleCtrl.text = widget.initialData!['title'] ?? '';

    final raw = widget.initialData!['questions'];
    final List list = raw is List ? raw : [];

    _questions.clear();
    for (final q in list) {
      _questions.add(McqQuestionForm.fromJson(q));
    }

    if (_questions.isEmpty) {
      _questions.add(McqQuestionForm());
    }
    return;
  }

  // ===== CREATE MODE =====
  _questions.clear();
  _questions.add(McqQuestionForm());
}


  void _addQuestion() {
    setState(() {
      _questions.add(McqQuestionForm());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  Future<void> _saveExercise() async {
    final title = _exerciseTitleCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên bài tập')),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cần ít nhất 1 câu hỏi')),
      );
      return;
    }
debugPrint('=== SAVE EXERCISE DEBUG ===');
debugPrint('Title: ${_exerciseTitleCtrl.text}');
debugPrint('Questions count: ${_questions.length}');
for (int i = 0; i < _questions.length; i++) {
  final q = _questions[i];
  debugPrint('Q$i: ${q.questionCtrl.text}');
  debugPrint('Options: ${q.optionCtrls.map((e) => e.text).toList()}');
  debugPrint('CorrectIndex: ${q.correctIndex}');
}

    try {
      final payload = {
        'title': title,
        'type': 'mcq',
        'questions': _questions.map((q) => q.toJson()).toList(),
        'updatedAt': DateTime.now(),
      };

      if (widget.isAiQuiz) {
  // 🔥 SỬA AI QUIZ → UPDATE ĐÚNG CHỖ
  await FirebaseFirestore.instance
      .collection('projects')
      .doc(widget.projectId)
      .collection('ai_quizzes')
      .doc(widget.exerciseId) // ID AI quiz
      .update({
        ...payload,
        'updatedAt': DateTime.now(),
      });
} else {
  // ===== BÀI THƯỜNG =====
  final ref = FirebaseFirestore.instance
      .collection('projects')
      .doc(widget.projectId)
      .collection('exercises');

  if (widget.isEdit) {
    await ref.doc(widget.exerciseId).update(payload);
  } else {
    await ref.add({
      ...payload,
      'createdAt': DateTime.now(),
    });
  }
}



      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);

   } catch (e, stack) {
  debugPrint('❌ SAVE ERROR: $e');
  debugPrint(stack.toString());

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Lỗi khi lưu bài tập: $e')),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FA),
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? 'Sửa bài tập trắc nghiệm'
              : 'Tạo bài tập trắc nghiệm',
        ),
        actions: [
          TextButton(
            onPressed: _saveExercise,
            child: const Text(
              'Lưu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // ===== EXERCISE TITLE =====
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _exerciseTitleCtrl,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Tên bài tập',
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ===== QUESTIONS =====
          ...List.generate(
            _questions.length,
            (index) => QuestionCard(
              index: index,
              form: _questions[index],
              onDelete: () => _removeQuestion(index),
            ),
          ),

          const SizedBox(height: 8),
          _AddQuestionButton(onTap: _addQuestion),
        ],
      ),
    );
  }
}

class _AddQuestionButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddQuestionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add),
      label: const Text('Thêm câu hỏi'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
