import 'package:flutter/material.dart';

class AccountModel {
  final String accountEmail;
  final String accountName;
  final String accountType;
  final String accountPassword;

  AccountModel({
    required this.accountEmail,
    required this.accountName,
    required this.accountType,
    required this.accountPassword,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      accountEmail: json['accountEmail'] ?? '', // Default to an empty string if it's null
      accountName: json['accountName'] ?? '',
      accountType: json['accountType'] ?? '',
      accountPassword: json['accountPassword'] ?? '',
    );
  }
}
