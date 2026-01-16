import 'package:flutter/material.dart';

class McqQuestionForm {
  final TextEditingController questionCtrl = TextEditingController();

  final List<TextEditingController> optionCtrls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  int correctIndex = 0;

  // ===== CONSTRUCTOR MẶC ĐỊNH (TẠO MỚI) =====
  McqQuestionForm();

factory McqQuestionForm.fromJson(Map<String, dynamic> json) {
  final form = McqQuestionForm();

  form.questionCtrl.text = (json['question'] ?? '').toString();

  final rawOptions = json['options'] ?? [];
  form.optionCtrls.clear();

  for (final opt in rawOptions) {
    // 🔥 CHỐT HẠ: DÙ AI HAY MANUAL ĐỀU ÉP STRING
    if (opt is String) {
      form.optionCtrls.add(TextEditingController(text: opt));
    } else if (opt is Map && opt['text'] != null) {
      form.optionCtrls.add(
        TextEditingController(text: opt['text'].toString()),
      );
    } else {
      form.optionCtrls.add(TextEditingController(text: ''));
    }
  }

  // đảm bảo tối thiểu 2 đáp án
  while (form.optionCtrls.length < 2) {
    form.optionCtrls.add(TextEditingController());
  }

  // tối đa 5
  if (form.optionCtrls.length > 5) {
    form.optionCtrls.removeRange(5, form.optionCtrls.length);
  }

  final ci = json['correctIndex'];
  form.correctIndex = ci is int ? ci : 0;
  if (form.correctIndex >= form.optionCtrls.length) {
    form.correctIndex = 0;
  }

  return form;
}


  // ===== OPTION HANDLER =====
  void addOption() {
    if (optionCtrls.length >= 5) return;
    optionCtrls.add(TextEditingController());
  }

  void removeOption(int index) {
    if (optionCtrls.length <= 2) return;
    optionCtrls.removeAt(index);
    if (correctIndex >= optionCtrls.length) {
      correctIndex = 0;
    }
  }

  // ===== SAVE FIRESTORE =====
  Map<String, dynamic> toJson() {
    return {
      'question': questionCtrl.text,
      'options': optionCtrls.map((e) => e.text).toList(),
      'correctIndex': correctIndex,
    };
  }
}
