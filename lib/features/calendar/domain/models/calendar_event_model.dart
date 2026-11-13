import 'package:flutter/material.dart';

enum CalendarViewMode { month, week }

/// Model Kategori Acara/Pengingat ala Samsung One UI
class CalendarCategoryItem {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final int count;

  const CalendarCategoryItem({
    required this.id,
    required this.name,
    required this.color,
    this.icon = Icons.notifications_rounded,
    this.count = 0,
  });

  CalendarCategoryItem copyWith({
    String? id,
    String? name,
    Color? color,
    IconData? icon,
    int? count,
  }) {
    return CalendarCategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      count: count ?? this.count,
    );
  }
}

/// Model Acara / Agenda / Pengingat ala Samsung One UI
class CalendarEventItem {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String duration;
  final String location;
  final Color color;
  final String category;
  final bool isCompleted;
  final bool isAllDay;
  final String repeatRule;
  final String reminderLevel;

  CalendarEventItem({
    required this.id,
    required this.title,
    DateTime? date,
    required this.time,
    this.duration = '1 jam',
    this.location = '',
    required this.color,
    required this.category,
    this.isCompleted = false,
    this.isAllDay = false,
    this.repeatRule = 'Jangan ulangi',
    this.reminderLevel = 'Sedang',
  }) : date = date ?? DateTime(2026, 10, 1);

  CalendarEventItem copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? time,
    String? duration,
    String? location,
    Color? color,
    String? category,
    bool? isCompleted,
    bool? isAllDay,
    String? repeatRule,
    String? reminderLevel,
  }) {
    return CalendarEventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      color: color ?? this.color,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      isAllDay: isAllDay ?? this.isAllDay,
      repeatRule: repeatRule ?? this.repeatRule,
      reminderLevel: reminderLevel ?? this.reminderLevel,
    );
  }
}
