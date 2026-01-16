import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String uid;
  final String name;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.createdAt,
  });

  factory ProjectModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ProjectModel(
      id: doc.id,
      uid: data['uid'] as String,
      name: data['name'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
