import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String text;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory JournalEntry.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final dynamic rawCreatedAt = data['createdAt'];

    DateTime createdAt;

    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.parse(rawCreatedAt);
    } else {
      createdAt = DateTime.now(); // absolute fallback
    }

    return JournalEntry(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: createdAt,
    );
  }
}