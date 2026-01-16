import 'package:flutter/material.dart';
import '../widgets/project_header.dart';
import '../widgets/project_action_grid.dart';
import '../widgets/project_exercise_list.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  final String projectName;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết project'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            ProjectHeader(projectName: projectName),

            // ===== ACTIONS =====
            ProjectActionGrid(projectId: projectId),


            // ===== LIST BÀI TẬP =====
            ProjectExerciseList(projectId: projectId),
          ],
        ),
      ),
    );
  }
}
