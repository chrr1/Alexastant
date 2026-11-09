import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/task_model.dart';
import 'priority_badge.dart';

class RichTaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onAiBreakdown;
  final Color cardBg;
  final Color cardBorder;
  final Color accentColor;
  final Color accentSoft;
  final Color accentLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color surfaceSecondary;

  const RichTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
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
    final isDone = task.status == TaskStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDone
              ? cardBorder
              : (task.priority == TaskPriority.urgent
                  ? accentColor.withOpacity(0.35)
                  : cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: isDone ? AppColors.success : textMuted,
                      width: 2,
                    ),
                  ),
                  child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDone ? textMuted : textPrimary,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        style: TextStyle(fontSize: 11, color: textSecondary, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PriorityBadge(priority: task.priority, accentColor: accentColor),
            ],
          ),
          const SizedBox(height: 12),
          if (task.subtasksTotal > 0 && !isDone) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checklist (${task.subtasksDone}/${task.subtasksTotal})',
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
                Text(
                  '${((task.subtasksDone / task.subtasksTotal) * 100).toInt()}%',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: accentLight),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: task.subtasksDone / task.subtasksTotal,
                backgroundColor: surfaceSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: surfaceSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.workspace,
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                    ),
                  ),
                  if (task.matkul != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '📚 ${task.matkul}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  ...task.tags.take(2).map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '#$tag',
                        style: TextStyle(fontSize: 9, color: textMuted),
                      ),
                    );
                  }),
                ],
              ),
              if (!isDone)
                GestureDetector(
                  onTap: onAiBreakdown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 10, color: accentLight),
                        const SizedBox(width: 3),
                        Text(
                          'AI Breakdown',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentLight),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

