import 'package:flutter/material.dart';
import '../controllers/grammar_controller.dart';
import 'grammar_detail_screen.dart';

class GrammarListScreen extends StatefulWidget {
  const GrammarListScreen({super.key});

  @override
  State<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<GrammarListScreen> {
  final GrammarController _controller = GrammarController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
    _controller.loadLessons();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Học Ngữ Pháp"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.errorMessage != null) {
            return Center(
              child: Text(
                "Lỗi: ${_controller.errorMessage}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (_controller.lessons.isEmpty) {
            return const Center(child: Text("Chưa có bài học nào. Vui lòng thêm dữ liệu trên Firebase."));
          }

          return ListView.builder(
            itemCount: _controller.lessons.length,
            itemBuilder: (context, index) {
              final lesson = _controller.lessons[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    lesson.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    lesson.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GrammarDetailScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
