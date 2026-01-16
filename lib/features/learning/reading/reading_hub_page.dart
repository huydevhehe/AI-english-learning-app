import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reading_controller.dart';
import 'reading_page.dart';

class ReadingHubPage extends StatelessWidget {
  const ReadingHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReadingController()..loadList(),
      child: const _ReadingHubView(),
    );
  }
}

class _ReadingHubView extends StatelessWidget {
  const _ReadingHubView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReadingController>();

    if (controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            controller.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Reading")),
      body: Column(
        children: [
          // ===== RANDOM BUTTON =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shuffle),
                label: const Text("Random bài đọc"),
                onPressed: () async {
                  await controller.loadRandom();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: controller,
                          child: const ReadingPage(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          const Divider(),

          // ===== LIST BÀI =====
          Expanded(
            child: ListView.builder(
              itemCount: controller.allPassages.length,
              itemBuilder: (_, i) {
                final p = controller.allPassages[i];
                return ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(p.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    controller.selectPassage(p);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: controller,
                          child: const ReadingPage(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
