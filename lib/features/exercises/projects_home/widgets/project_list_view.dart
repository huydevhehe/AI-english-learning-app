import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/projects_provider.dart';
import '../models/project_model.dart';
import 'project_card.dart';

class ProjectListView extends StatelessWidget {
  final String uid;
  const ProjectListView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProjectsProvider>();

    return StreamBuilder<List<ProjectModel>>(
      stream: provider.projects(uid),
      builder: (context, snapshot) {
        // ✅ Chỉ loading khi đang kết nối
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final projects = snapshot.data ?? [];

        // ✅ EMPTY STATE – không xoay, không khó chịu
        if (projects.isEmpty) {
          return const _EmptyProjectsView();
        }

        // ✅ Có project → list
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: projects.length,
          itemBuilder: (_, i) {
            return ProjectCard(project: projects[i]);
          },
        );
      },
    );
  }
}

// ================= EMPTY STATE =================
class _EmptyProjectsView extends StatelessWidget {
  const _EmptyProjectsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== ICON CHÍNH =====
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF8E7CFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_stories_rounded, // 📘 học – project – bài tập
                size: 46,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // ===== TITLE =====
            const Text(
              'Chưa có project nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // ===== SUBTITLE =====
            Text(
              'Tạo một project để bắt đầu\nxây dựng bài tập và học cùng AI',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
