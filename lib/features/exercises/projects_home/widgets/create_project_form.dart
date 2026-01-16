import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/projects_provider.dart';

class CreateProjectForm extends StatefulWidget {
  final String uid;
  const CreateProjectForm({super.key, required this.uid});

  @override
  State<CreateProjectForm> createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends State<CreateProjectForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProjectsProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        color: const Color(0xFFF8F5FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== TITLE =====
              const Text(
                'Tạo project bài tập',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // ===== INPUT =====
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Từ vựng TOEIC',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== BUTTON =====
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await provider.createProject(
                      uid: widget.uid,
                      name: _controller.text,
                    );
                    _controller.clear();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
