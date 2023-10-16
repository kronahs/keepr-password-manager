
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keepr/models/user_models.dart';

class UserRepository{
  final _db = FirebaseFirestore.instance;


  createUser(UserModel user) async{
    await _db.collection("Users").add(user.toJson()).whenComplete(
            () => print('Successfully account created')
    ) ;
  }

}