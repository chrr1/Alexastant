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
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.date,
    this.accentColor = const Color(0xFF6366F1),
    this.category = NoteCategory.lainnya,
    this.matkul,
    this.isPinned = false,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? tags,
    String? date,
    Color? accentColor,
    NoteCategory? category,
    String? matkul,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      accentColor: accentColor ?? this.accentColor,
      category: category ?? this.category,
      matkul: matkul ?? this.matkul,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
