import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/project.dart';

class PortfolioService {
  final _col = FirebaseFirestore.instance.collection('portfolio');

  Future<List<Project>> fetchProjects() async {
    final snap = await _col.orderBy('createdAt', descending: true).get();
    final storage = FirebaseStorage.instance;

    return Future.wait(snap.docs.map((doc) async {
      final data = doc.data();
      // pull out the raw URLs from Firestore
      final rawUrls = List<String>.from(data['imageUrls'] ?? []);

      // for each rawUrl, if it’s gs://… fetch its HTTP URL, otherwise keep it
      final resolvedUrls = await Future.wait(rawUrls.map((raw) {
        if (raw.startsWith('gs://')) {
          return storage.refFromURL(raw).getDownloadURL();
        } else {
          return Future.value(raw);
        }
      }));

      return Project(
        id: doc.id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        imageUrls: resolvedUrls,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        tags: List<String>.from(data['tags'] ?? []),
      );
    }));
  }

  Stream<List<Project>> projectsStream() {
    final storage = FirebaseStorage.instance;

    return _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snap) async {
      return Future.wait(snap.docs.map((doc) async {
        final data = doc.data();
        final rawUrls = List<String>.from(data['imageUrls'] ?? []);
        final resolvedUrls = await Future.wait(rawUrls.map((raw) {
          if (raw.startsWith('gs://')) {
            return storage.refFromURL(raw).getDownloadURL();
          }
          return Future.value(raw);
        }));
        return Project(
          id: doc.id,
          title: data['title'] as String? ?? '',
          description: data['description'] as String? ?? '',
          imageUrls: resolvedUrls,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
          tags: List<String>.from(data['tags'] ?? []),
        );
      }));
    });
  }
}
