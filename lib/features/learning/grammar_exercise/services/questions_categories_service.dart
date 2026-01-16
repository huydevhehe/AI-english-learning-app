import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/questions_categories_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy toàn bộ category trong Firestore
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection("grammar_categories_exercises")
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel(name: doc.id)) // chỉ có name = doc.id
          .toList();
    } catch (e) {
      throw Exception("Load categories failed: $e");
    }
  }
}
