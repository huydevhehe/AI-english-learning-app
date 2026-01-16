import 'package:flutter/material.dart';
import 'vocab_topic_model.dart';
import 'vocab_topic_service.dart';

class VocabTopicController extends ChangeNotifier {
  final VocabTopicService service = VocabTopicService();

  List<VocabTopicModel> topics = [];
  bool loading = false;

  Future<void> loadTopics() async {
    loading = true;
    notifyListeners();

    topics = await service.fetchTopics();

    loading = false;
    notifyListeners();
  }
}
