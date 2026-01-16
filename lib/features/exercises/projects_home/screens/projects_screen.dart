import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../provider/projects_provider.dart';
import '../widgets/create_project_form.dart';
import '../widgets/project_list_view.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return ChangeNotifierProvider(
      create: (_) => ProjectsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bài tập'),
        ),
        body: Column(
          children: [
            CreateProjectForm(uid: uid),
            Expanded(
              child: ProjectListView(uid: uid),
            ),
          ],
        ),
      ),
    );
  }
}
