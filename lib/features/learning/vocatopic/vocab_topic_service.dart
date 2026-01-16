import 'package:cloud_firestore/cloud_firestore.dart';
import 'vocab_topic_model.dart';
import 'vocab_topic_question_model.dart';

class VocabTopicService {
  final _db = FirebaseFirestore.instance;

  // ===== LẤY TOPIC =====
  Future<List<VocabTopicModel>> fetchTopics() async {
    final snap = await _db.collection('vocab_topics').get();

    return snap.docs
        .map((d) => VocabTopicModel.fromMap(d.id, d.data()))
        .toList();
  }

  // ===== LẤY CÂU HỎI THEO TOPIC =====
  Future<List<VocabTopicQuestion>> fetchQuestions(String topicKey) async {
    final snap = await _db
        .collection('vocab_questions')
        .where('topicId', isEqualTo: topicKey)
        .get();

    return snap.docs
        .map((d) => VocabTopicQuestion.fromMap(d.data()))
        .toList();
  }
}
