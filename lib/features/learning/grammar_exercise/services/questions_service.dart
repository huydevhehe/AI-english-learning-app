import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/questions_model.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy 10 câu hỏi ngẫu nhiên của 1 category
  Future<List<QuestionModel>> getQuestions(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection("grammar_categories_exercises")
          .doc(categoryId)
          .collection("questions")
          .doc("set1") // lưu toàn bộ câu trong set1
          .get();

      if (!snapshot.exists) return [];

      final data = snapshot.data() as Map<String, dynamic>;

      // Convert map {q1: {...}, q2: {...}} → List<QuestionModel>
      List<QuestionModel> questions = data.entries.map((entry) {
        return QuestionModel.fromMap(entry.value, entry.key);
      }).toList();

      // Random 10 câu (hoặc tất cả nếu <10)
      questions.shuffle();
      if (questions.length > 10) {
        questions = questions.sublist(0, 10);
      }

      return questions;
    } catch (e) {
      print("Error fetching questions: $e");
      return [];
    }
  }
}
