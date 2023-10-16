
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keepr/models/user_models.dart';
import 'package:keepr/services/firebase_auth.dart';

import '../models/account_models.dart';

class AccountRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<AccountModel>> fetchSocialMediaAccountsStream() {
    User? user = _auth.currentUser;
    final socialMediaCollection =
    _db.collection('users').doc(user?.uid).collection('SMAccounts');

    return socialMediaCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AccountModel.fromJson(data);
      }).toList();
    });
  }
}

