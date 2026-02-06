import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/journal_model.dart';

class JournalController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final journals = <JournalEntry>[].obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _bindJournalStream();
  }

  void _bindJournalStream() {
    final uid = _auth.currentUser!.uid;

    _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      journals.value =
          snapshot.docs.map((e) => JournalEntry.fromDoc(e)).toList();
    });
  }

  Future<void> addJournal(String text) async {
    if (text.trim().isEmpty) return;

    isSaving.value = true;

    final uid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .add(
      JournalEntry(
        id: '',
        text: text,
        createdAt: DateTime.now(),
      ).toMap(),
    );

    isSaving.value = false;
  }

  Future<void> updateJournal(String id, String text) async {
    final uid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(id)
        .update({
      'text': text,
    });
  }

  Future<void> deleteJournal(String id) async {
    final uid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(id)
        .delete();
  }
}