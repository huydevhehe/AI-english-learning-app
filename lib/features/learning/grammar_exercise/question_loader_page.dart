import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../grammar_exercise/screens/questions_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> categories = [];
  List<String> filtered = [];
  bool loading = false;

  // Map chuyển tên sang tiếng Việt
  final Map<String, String> vnNames = {
    "simple_present": "Thì hiện tại đơn",
    "simple_past": "Thì quá khứ đơn",
    "simple_future": "Thì tương lai đơn",
    "present_continuous": "Thì hiện tại tiếp diễn",
    "past_continuous": "Thì quá khứ tiếp diễn",
    "future_continuous": "Thì tương lai tiếp diễn",
    "present_perfect": "Thì hiện tại hoàn thành",
    "past_perfect": "Thì quá khứ hoàn thành",
    "future_perfect": "Thì tương lai hoàn thành",
    "present_perfect_continuous": "Thì hiện tại hoàn thành tiếp diễn",
    "past_perfect_continuous": "Thì quá khứ hoàn thành tiếp diễn",
    "future_perfect_continuous": "Thì tương lai hoàn thành tiếp diễn",
  };

  // Hàm đổi simple_present → Simple Present
  String formatTitle(String raw) {
    return raw
        .replaceAll("_", " ")
        .split(" ")
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(" ");
  }

  Future<void> loadCategories() async {
    setState(() => loading = true);

    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection("grammar_categories_exercises")
        .get();

    categories = snapshot.docs.map((doc) => doc.id).toList();
    filtered = List.from(categories);

    setState(() => loading = false);
  }

  void search(String text) {
    setState(() {
      filtered = categories
          .where((c) => c.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Grammar Categories"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: search,
                    decoration: InputDecoration(
                      hintText: "Search grammar topics...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,

                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final category = filtered[index];
                      final title = formatTitle(category);
                      final vn = vnNames[category] ?? "Bài tập ngữ pháp";

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExerciseScreen(categoryName: category),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // ICON
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.menu_book,
                                  size: 26,
                                  color: Colors.blue.shade700,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // TÊN BÀI TẬP
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vn,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Quay lại",
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 5, 25, 204)),
          ),
        ),
      ),
    );
  }
}
