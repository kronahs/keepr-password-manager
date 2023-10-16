import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteModel {
  final String noteTitle;
  final String noteBody;
  final DateTime editedDate;
  final int color;

  NoteModel({
    required this.noteTitle,
    required this.noteBody,
    required this.editedDate,
    required this.color,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      noteTitle: json['noteTitle'] ?? '', // Default to an empty string if it's null
      noteBody: json['noteBody'] ?? '',
      editedDate: (json['editedDate'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      color: json['color'] ?? Colors.white.value, // Parse color from int value in the JSON object
    );
  }
}
