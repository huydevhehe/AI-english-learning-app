import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/exercise_detail_screen.dart';
import '../../manual_create/screens/create_manual_screen.dart';

class ProjectExerciseList extends StatelessWidget {
  final String projectId;

  const ProjectExerciseList({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final collectionRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('exercises');

    final query = collectionRef.orderBy('createdAt', descending: true);
final aiQuizRef = FirebaseFirestore.instance
    .collection('projects')
    .doc(projectId)
    .collection('ai_quizzes');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bài tập đã tạo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
/// ===== AI QUIZ (DO AI TẠO) =====
StreamBuilder<QuerySnapshot>(
  stream: aiQuizRef.orderBy('createdAt', descending: true).snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const SizedBox();

    final docs = snapshot.data!.docs;
    if (docs.isEmpty) return const SizedBox();

    return Column(
      children: docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF80DEEA)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.smart_toy, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data['title'] ?? 'AI Quiz',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseDetailScreen(
                        projectId: projectId,
                        exerciseId: doc.id,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
  icon: const Icon(Icons.edit, color: Colors.white),
  onPressed: () {
    // 🔥 CHUYỂN AI QUIZ → DẠNG MANUAL
    final fixedData = {
  'title': data['title'],
  'createdAt': data['createdAt'],
  'questions': (data['questions'] as List).map((q) {
    final options = q['options'] as List;

    return {
      'question': q['question'],
      'options': options.map((o) => o['text']).toList(),
      'correctIndex': options.indexWhere(
        (o) => o['key'] == q['correctAnswer'],
      ),
    };
  }).toList(),
};


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateManualScreen(
          projectId: projectId,
          exerciseId: doc.id,
          initialData: fixedData,
           isAiQuiz: true,   // ✅ DATA ĐÃ FIX
        ),
      ),
    );
  },
),

              IconButton(
                icon:
                    const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () async {
                  final ok = await _confirmDelete(context);
                  if (!ok) return;

                  await aiQuizRef.doc(doc.id).delete();
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
),

          StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return _EmptyView();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return _ExerciseItem(
                    title: data['title'] ?? 'Bài tập',
                    onPlay: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseDetailScreen(
                            projectId: projectId,
                            exerciseId: doc.id,
                          ),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateManualScreen(
                            projectId: projectId,
                            exerciseId: doc.id, // 🔥 QUAN TRỌNG
                            initialData: data, // 🔥 QUAN TRỌNG
                          ),
                        ),
                      );
                    },

                    onDelete: () async {
                      final ok = await _confirmDelete(context);
                      if (!ok) return;

                      await collectionRef.doc(doc.id).delete();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Xoá bài tập?'),
          content: const Text('Bài tập sẽ bị xoá vĩnh viễn.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xoá'),
            ),
          ],
        ),
      ) ??
      false;
}

class _ExerciseItem extends StatelessWidget {
  final String title;
  final VoidCallback onPlay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExerciseItem({
    required this.title,
    required this.onPlay,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF7ED), // cam rất nhạt
            Color(0xFFFFFBF5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFE0B2), // viền cam nhạt
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ===== ICON TRÁI =====
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFA726),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.quiz_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // ===== TITLE =====
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ===== ACTIONS =====
          IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Colors.green.shade600,
            onPressed: onPlay,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: Colors.blueGrey,
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.redAccent,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}


class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: const [
          Icon(Icons.library_books_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Chưa có bài tập nào'),
        ],
      ),
    );
  }
}
