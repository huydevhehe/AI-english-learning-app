import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grammar_lesson_model.dart';

class GrammarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<GrammarLessonModel>> getLessons() async {
    try {
      final snapshot = await _firestore.collection("grammar_lessons").get();

      return snapshot.docs
          .map((doc) => GrammarLessonModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception("Failed to load grammar lessons: $e");
    }
  }

  Future<GrammarLessonModel?> getLessonById(String id) async {
    try {
      final doc = await _firestore.collection("grammar_lessons").doc(id).get();
      if (doc.exists) {
        return GrammarLessonModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to load grammar lesson: $e");
    }
  }
}
