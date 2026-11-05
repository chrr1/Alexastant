import 'package:flutter/material.dart';

enum CalendarViewMode { month, week }

class CalendarEventItem {
  final String id;
  final String title;
  final String time;
  final String duration;
  final String location;
  final Color color;
  final String category;
  final bool isCompleted;

  CalendarEventItem({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    required this.location,
    required this.color,
    required this.category,
    this.isCompleted = false,
  });
}

