import 'package:flutter/material.dart';

class UserModel{
  final String? id;
  final String fullName;
  final String email;
  final String username;
  final String password;

  const UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
});

  toJson() {
    return{
      "FullName" : fullName,
      "Email" : email,
      "Username" : username,
      "Password": password,
    };
  }
}