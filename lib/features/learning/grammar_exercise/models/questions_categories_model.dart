class CategoryModel {
  final String name;

  CategoryModel({required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(name: map['name'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
