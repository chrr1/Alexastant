import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';
import 'rich_task_card.dart';

class AllListView extends StatelessWidget {
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onToggleTask;
  final ValueChanged<TaskModel> onAiBreakdown;
  final Color cardBg;
  final Color cardBorder;
  final Color accentColor;
  final Color accentSoft;
  final Color accentLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color surfaceSecondary;

  const AllListView({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.onAiBreakdown,
    required this.cardBg,
    required this.cardBorder,
    required this.accentColor,
    required this.accentSoft,
    required this.accentLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.surfaceSecondary,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Text('Tidak ada tugas ditemukan', style: TextStyle(color: textSecondary)),
      );
    }

    return Column(
      children: tasks
          .map((task) => RichTaskCard(
                task: task,
                onToggle: () => onToggleTask(task),
                onAiBreakdown: () => onAiBreakdown(task),
                cardBg: cardBg,
                cardBorder: cardBorder,
                accentColor: accentColor,
                accentSoft: accentSoft,
                accentLight: accentLight,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                textMuted: textMuted,
                surfaceSecondary: surfaceSecondary,
              ))
          .toList(),
    );
  }
}

