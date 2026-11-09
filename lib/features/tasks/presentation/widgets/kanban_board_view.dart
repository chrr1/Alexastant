import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/task_model.dart';
import 'priority_badge.dart';

class KanbanBoardView extends StatelessWidget {
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onCompleteTask;
  final Color cardBg;
  final Color cardBorder;
  final Color cardInnerBg;
  final Color accentColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color surfaceSecondary;

  const KanbanBoardView({
    super.key,
    required this.tasks,
    required this.onCompleteTask,
    required this.cardBg,
    required this.cardBorder,
    required this.cardInnerBg,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.surfaceSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildColumn('To Do', TaskStatus.todo, AppColors.info, Icons.radio_button_unchecked_rounded),
        const SizedBox(height: 16),
        _buildColumn('In Progress', TaskStatus.inProgress, accentColor, Icons.autorenew_rounded),
        const SizedBox(height: 16),
        _buildColumn('Completed', TaskStatus.completed, AppColors.success, Icons.check_circle_rounded),
      ],
    );
  }

  Widget _buildColumn(String title, TaskStatus status, Color colAccent, IconData icon) {
    final tasksInColumn = tasks.where((t) => t.status == status).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: colAccent),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${tasksInColumn.length}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tasksInColumn.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('Kosong', style: TextStyle(fontSize: 11, color: textMuted)),
              ),
            )
          else
            ...tasksInColumn.map((task) => _buildCard(task)),
        ],
      ),
    );
  }

  Widget _buildCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    task.workspace,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecondary),
                  ),
                  if (task.matkul != null) ...[
                    Text(' • ', style: TextStyle(fontSize: 9, color: textMuted)),
                    Text(
                      task.matkul!,
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentColor),
                    ),
                  ],
                ],
              ),
              PriorityBadge(priority: task.priority, accentColor: accentColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            task.title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: task.tags.take(2).map((tag) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(fontSize: 8, color: textSecondary),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  if (task.status != TaskStatus.completed)
                    GestureDetector(
                      onTap: () => onCompleteTask(task),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 12, color: AppColors.success),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

