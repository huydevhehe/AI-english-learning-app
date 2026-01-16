import 'package:flutter/material.dart';
import '../controllers/questions_controller.dart';
import '../widgets/questions_list_widget.dart';
import '../screens/answers_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final String categoryName;

  const ExerciseScreen({super.key, required this.categoryName});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final controller = QuestionController();

  /// Map lưu đáp án user chọn: questionIndex -> optionIndex
  final Map<int, int> selectedAnswers = {};

  @override
  void initState() {
    super.initState();

    controller.loadQuestions(widget.categoryName).then((_) {
      setState(() {});
    });
  }

  void submitAnswers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnswerScreen(
          questions: controller.questions,
          selectedAnswers: selectedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise: ${widget.categoryName}"),
        centerTitle: true,
      ),

      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
          ? Center(
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            )
          : controller.questions.isEmpty
          ? const Center(
              child: Text(
                "No questions found!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];

                      return QuestionItemWidget(
                        question: question,
                        selectedIndex: selectedAnswers[index],
                        onOptionSelected: (value) {
                          setState(() {
                            selectedAnswers[index] = value;
                          });
                        },
                      );
                    },
                  ),
                ),

                /// Nút nộp bài
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    onPressed:
                        selectedAnswers.length == controller.questions.length
                        ? submitAnswers
                        : null,
                    child: const Text(
                      "NỘP BÀI",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
