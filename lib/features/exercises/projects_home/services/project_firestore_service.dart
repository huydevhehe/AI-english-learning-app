import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class ProjectFirestoreService {
  final _col = FirebaseFirestore.instance.collection('projects');

  Stream<List<ProjectModel>> watchProjects(String uid) {
    return _col
        .where('uid', isEqualTo: uid)
        // ❌ bỏ orderBy
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ProjectModel.fromDoc(d))
              .toList(),
        );
  }

  Future<void> createProject({
    required String uid,
    required String name,
  }) async {
    await _col.add({
      'uid': uid,
      'name': name.trim(),
      'createdAt': DateTime.now(), // ✅ client time
    });
  }
}
