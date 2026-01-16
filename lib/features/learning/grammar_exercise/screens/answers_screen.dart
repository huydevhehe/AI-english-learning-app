import 'package:flutter/material.dart';
import '../models/questions_model.dart';
import '../widgets/answers_widget.dart';
import '../../grammar_exercise/question_loader_page.dart'; // <-- import trang category

class AnswerScreen extends StatelessWidget {
  final List<QuestionModel> questions;
  final Map<int, int> selectedAnswers;

  const AnswerScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ResultWidget(
        questions: questions,
        selectedAnswers: selectedAnswers,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const CategoriesScreen()),
              (route) =>
                  false, // xoá hết stack -> quay về đúng trang danh sách categories
            );
          },
          child: Text(
            "Quay lại danh sách chủ đề",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
