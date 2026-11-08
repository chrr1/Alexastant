import 'package:flutter/material.dart';

class TasksTopHeader extends StatelessWidget {
  final Color textPrimary;
  final Color textSecondary;
  final Color topBtnBg;
  final Color topBtnBorder;
  final Color topIconColor;
  final VoidCallback? onFilterTap;

  const TasksTopHeader({
    super.key,
    required this.textPrimary,
    required this.textSecondary,
    required this.topBtnBg,
    required this.topBtnBorder,
    required this.topIconColor,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugas & Proyek',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Senin, 02 November 2026',
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
        // Filter button
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: topBtnBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: topBtnBorder),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: topIconColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

