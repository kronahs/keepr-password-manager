import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keepr/models/note_models.dart';

class NoteRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<NoteModel>> fetchSecureNotesStream() {
    User? user = _auth.currentUser;
    final secureNotesCollection =
    _db.collection('users').doc(user?.uid).collection('SecureNotes');

    return secureNotesCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NoteModel.fromJson(data);
      }).toList();
    });
  }
}
