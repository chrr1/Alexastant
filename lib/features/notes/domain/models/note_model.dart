import 'package:flutter/material.dart';

enum NoteCategory { kuliah, pribadi, ide, rapat, tech, lainnya }

class NoteModel {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final String date;
  final Color accentColor;
  final NoteCategory category;
  final String? matkul; // only for kuliah category

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.date,
    required this.accentColor,
    this.category = NoteCategory.lainnya,
    this.matkul,
  });
}

