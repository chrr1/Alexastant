import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/task_model.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final Color accentColor;

  const PriorityBadge({
    super.key,
    required this.priority,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    Color col;
    String label;
    switch (priority) {
      case TaskPriority.urgent:
        col = accentColor;
        label = 'Urgent';
        break;
      case TaskPriority.high:
        col = AppColors.warning;
        label = 'Tinggi';
        break;
      case TaskPriority.medium:
        col = AppColors.info;
        label = 'Sedang';
        break;
      case TaskPriority.low:
        col = AppColors.success;
        label = 'Rendah';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: col.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: col),
      ),
    );
  }
}

