import 'package:flutter/material.dart';
import '../services/mcq_parser.dart';

class DocumentTextController extends ChangeNotifier {
  bool analyzing = false;
  String? error;
  McqParseResult? result;

  Future<void> analyze(String raw) async {
    if (raw.trim().isEmpty) return;

    analyzing = true;
    error = null;
    result = null;
    notifyListeners();

    try {
      final parseResult = McqParser.parseWithReport(raw);

      if (parseResult.questions.isEmpty) {
        throw Exception();
      }

      result = parseResult;
    } catch (_) {
      error =
          'Nội dung không đúng định dạng trắc nghiệm.\n'
          'Vui lòng kiểm tra lại.';
    }

    analyzing = false;
    notifyListeners();
  }

  void reset() {
    error = null;
    result = null;
    notifyListeners();
  }
}
