import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';

class BentoTaskItem extends StatelessWidget {
  final TaskModel task;
  final bool onAccentBackground;
  final Color accentColor;
  final Color accentSoft;
  final Color accentLight;
  final Color surfaceSecondary;
  final Color cardBorder;
  final Color textPrimary;
  final Color textMuted;
  final Color textSecondary;
  final VoidCallback onToggle;

  const BentoTaskItem({
    super.key,
    required this.task,
    required this.onAccentBackground,
    required this.accentColor,
    required this.accentSoft,
    required this.accentLight,
    required this.surfaceSecondary,
    required this.cardBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.textSecondary,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.completed;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: onAccentBackground ? Colors.black.withOpacity(0.15) : surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: onAccentBackground ? Colors.white.withOpacity(0.1) : cardBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? (onAccentBackground ? Colors.white : accentColor)
                    : Colors.transparent,
                border: Border.all(
                  color: isDone
                      ? (onAccentBackground ? Colors.white : accentColor)
                      : (onAccentBackground ? Colors.white70 : textMuted),
                  width: 1.8,
                ),
              ),
              child: isDone
                  ? Icon(Icons.check, size: 12,
                      color: onAccentBackground ? accentColor : Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDone
                          ? (onAccentBackground ? Colors.white60 : textMuted)
                          : (onAccentBackground ? Colors.white : textPrimary),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (task.matkul != null) ...[
                        Text(
                          '📚 ${task.matkul}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: onAccentBackground ? Colors.white : accentColor,
                          ),
                        ),
                        if (task.subtasksTotal > 0)
                          Text(
                            ' • ',
                            style: TextStyle(
                              fontSize: 9,
                              color: onAccentBackground ? Colors.white60 : textMuted,
                            ),
                          ),
                      ],
                      if (task.subtasksTotal > 0)
                        Text(
                          '${task.subtasksDone}/${task.subtasksTotal} langkah selesai',
                          style: TextStyle(
                            fontSize: 9,
                            color: onAccentBackground ? Colors.white70 : textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (task.priority == TaskPriority.urgent && !isDone)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: onAccentBackground ? Colors.white : accentSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Urgent',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: onAccentBackground ? accentColor : accentColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

