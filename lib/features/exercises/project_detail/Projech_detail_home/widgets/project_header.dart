import 'package:flutter/material.dart';

class ProjectHeader extends StatelessWidget {
  final String projectName;

  const ProjectHeader({
    super.key,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              size: 20,
              color: Color(0xFFFF9800),
            ),
          ),
          const SizedBox(width: 10),

          // PROJECT NAME (gọn, không chiếm full ngang)
          Flexible(
            child: Text(
              projectName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
