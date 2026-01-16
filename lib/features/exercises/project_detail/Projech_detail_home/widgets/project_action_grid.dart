import 'package:flutter/material.dart';
import '../../manual_create/screens/create_manual_screen.dart';  
import '../../document_import/screens/document_text_input_screen.dart';
import 'package:provider/provider.dart';
import '../../ai_exercise/controller/ai_quiz_controller.dart';
import '../../ai_exercise/screens/ai_quiz_input_screen.dart';


class ProjectActionGrid extends StatelessWidget {
  final String projectId;

  const ProjectActionGrid({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio:  1.7,
        ),
        children: [
          _ActionTile(
            title: 'Tạo thủ công',
            subtitle: 'Nhập câu hỏi trực tiếp',
            icon: Icons.add,
            gradient: const LinearGradient(
              colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CreateManualScreen(projectId: projectId),
                ),
              );
            },
          ),
          const _ActionTile(
            title: 'Quét hình ảnh',
            subtitle: 'Upload ảnh để tạo quiz',
            icon: Icons.camera_alt,
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            ),
          ),
          _ActionTile(
  title: 'Nhập bài dạng Text',
  subtitle: ' Tạo bài bằng Text ',
  icon: Icons.description,
  gradient: const LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentTextInputScreen(
          projectId: projectId,
        ),
      ),
    );
  },
),

          _ActionTile(
  title: 'AI tạo tự động',
  subtitle: 'Tạo trắc nghiệm bằng AI',
  icon: Icons.smart_toy,
  gradient: const LinearGradient(
    colors: [Color(0xFF26C6DA), Color(0xFF80DEEA)],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
  create: (_) => AiQuizController(projectId: projectId),
  child: const AiQuizInputScreen(),
),

      ),
    );
  },
),

        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
