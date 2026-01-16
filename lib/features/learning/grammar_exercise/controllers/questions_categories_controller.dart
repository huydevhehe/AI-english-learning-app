import 'package:flutter/material.dart';
import '../models/questions_categories_model.dart';
import '../services/questions_categories_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<CategoryModel> categories = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await _service.getCategories();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
