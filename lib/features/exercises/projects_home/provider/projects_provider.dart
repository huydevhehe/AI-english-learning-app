import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_firestore_service.dart';

class ProjectsProvider extends ChangeNotifier {
  final _service = ProjectFirestoreService();

  Stream<List<ProjectModel>> projects(String uid) {
    return _service.watchProjects(uid);
  }

  Future<void> createProject({
    required String uid,
    required String name,
  }) async {
    if (name.trim().isEmpty) return;
    await _service.createProject(uid: uid, name: name);
  }
}
