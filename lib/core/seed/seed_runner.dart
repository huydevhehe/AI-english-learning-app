  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'reading_seed_data.dart';
  import 'vocab_seed_data.dart';
  import 'vocab_topic_seed_data.dart';
  import 'listening_seed.dart';
  class SeedRunner {
   // =========================
// 📘 READING SEED (MỞ RỘNG)
// =========================
static Future<void> runReadingSeedOnce() async {
  final db = FirebaseFirestore.instance;

  for (final item in readingSeedData) {
    final docRef =
        db.collection('reading_passages').doc(item['id']);

    final docSnap = await docRef.get();

    // ✅ Nếu bài đã tồn tại → bỏ qua
    if (docSnap.exists) continue;

    // ✅ Chỉ thêm bài CHƯA CÓ
    await docRef.set({
      'title': item['title'],
      'content': item['content'],
      'questions': item['questions'],
    });
  }
}

    // =========================
    // 📕 VOCAB SEED
    // =========================
    static Future<void> runVocabSeedOnce() async {
      final db = FirebaseFirestore.instance;

      final systemRef = db.collection('_system').doc('seed');
      final systemSnap = await systemRef.get();

      if (systemSnap.exists &&
          systemSnap.data()?['vocab_seeded'] == true) {
        return;
      }

      final batch = db.batch();

      for (final item in vocabSeedData) {
        final docRef = db.collection('vocab_questions').doc();

        batch.set(docRef, {
          'topicId': item['topicId'],
          'question': item['question'],
          'answers': item['answers'],
          'correct': item['correct'],
          'icon': item['icon'],
        });
      }

      await batch.commit();

      await systemRef.set({
        'vocab_seeded': true,
        'vocabSeededAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    // =======================
    // VOCAB TOPIC (MỚI)
    // =======================
    static Future<void> runVocabTopicSeedOnce() async {
      final db = FirebaseFirestore.instance;

      final systemRef = db.collection('_system').doc('seed');
      final systemSnap = await systemRef.get();

      if (systemSnap.exists &&
          systemSnap.data()?['vocab_topic_seeded'] == true) {
        return;
      }

      for (final item in vocabTopicSeedData) {
        final docRef =
      db.collection('vocab_topics').doc(item['id'] as String);


        final docSnap = await docRef.get();
        if (docSnap.exists) continue;

        await docRef.set({
          'topicKey': item['topicKey'],
          'title': item['title'],
          'emoji': item['emoji'],
          'totalWords': item['totalWords'],
        });
      }

      await systemRef.set({
        'vocab_topic_seeded': true,
      }, SetOptions(merge: true));
    }
  // =========================
  // 🎧 LISTENING SEED
  // =========================
  static Future<void> runListeningSeedOnce() async {
    final db = FirebaseFirestore.instance;

    final systemRef = db.collection('_system').doc('seed');
    final systemSnap = await systemRef.get();

    if (systemSnap.exists &&
        systemSnap.data()?['listening_seeded'] == true) {
      return;
    }

    final batch = db.batch();

    for (final item in listeningSeedData) {
      final docRef = db.collection('listening_questions').doc();

      batch.set(docRef, {
        'fullSentence': item['fullSentence'],
        'missingWord': item['missingWord'],
        'options': item['options'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    await systemRef.set({
      'listening_seeded': true,
      'listeningSeededAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  }
