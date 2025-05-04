// lib/models/project.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
  });

  factory Project.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Project(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrls: List<String>.from(data['imageUrls'] as List<dynamic>? ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(data['tags'] as List<dynamic>? ?? []),
    );
  }
}
