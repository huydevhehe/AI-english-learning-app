import 'package:cloud_firestore/cloud_firestore.dart';
import 'listening_question_model.dart';

class ListeningService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy danh sách câu listening từ Firestore
  Future<List<ListeningQuestion>> fetchListeningQuestions() async {
    final snapshot =
        await _firestore.collection('listening_questions').get();

    return snapshot.docs
        .map(
          (doc) => ListeningQuestion.fromFirestore(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }
}
