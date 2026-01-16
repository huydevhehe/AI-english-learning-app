import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vocab_topic_controller.dart';
import 'vocab_quiz_page.dart';

class VocabTopicsPage extends StatelessWidget {
  const VocabTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabTopicController()..loadTopics(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Chủ đề từ vựng"),
          elevation: 0,
          centerTitle: true,
        ),
        body: Consumer<VocabTopicController>(
          builder: (context, c, _) {
            if (c.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: c.topics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .78,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, i) {
                  final t = c.topics[i];

                  return GestureDetector(
                    onTap: () {
                      debugPrint(
                        "🔥 TAP TOPIC: ${t.title} | key=${t.topicKey}",
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VocabQuizPage(topicId: t.topicKey),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.emoji, style: const TextStyle(fontSize: 36)),
                          const SizedBox(height: 8),
                          Text(
                            t.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 6),
                          Text(
                            "${t.completed}/${t.totalWords} hoàn thành",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: t.completed / t.totalWords,
                            backgroundColor: Theme.of(context).dividerColor,
                            color: Theme.of(context).colorScheme.primary,
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
