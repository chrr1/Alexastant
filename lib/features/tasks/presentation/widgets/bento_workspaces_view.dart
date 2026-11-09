import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';
import 'bento_task_item.dart';

class BentoWorkspacesView extends StatelessWidget {
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onToggleTask;
  final double t;
  final Color accentColor;
  final LinearGradient accentGradient;
  final Color accentGlow;
  final Color accentSoft;
  final Color accentLight;
  final Color cardBg;
  final Color cardBorder;
  final Color surfaceSecondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const BentoWorkspacesView({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.t,
    required this.accentColor,
    required this.accentGradient,
    required this.accentGlow,
    required this.accentSoft,
    required this.accentLight,
    required this.cardBg,
    required this.cardBorder,
    required this.surfaceSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    final workspaces = ['Kuliah', 'Tugas Harian', 'Pribadi'];

    return Column(
      children: workspaces.map((ws) {
        final wsTasks = tasks.where((t2) => t2.workspace == ws).toList();
        if (wsTasks.isEmpty) return const SizedBox.shrink();

        final done = wsTasks.where((t2) => t2.status == TaskStatus.completed).length;
        final total = wsTasks.length;
        final wsProgress = total > 0 ? (done / total) : 0.0;
        final isAccentCard = ws == 'Tugas Harian';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: isAccentCard ? accentGradient : null,
            color: isAccentCard ? null : cardBg,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: isAccentCard ? Colors.transparent : cardBorder),
            boxShadow: isAccentCard
                ? [BoxShadow(color: accentGlow, blurRadius: 18, offset: const Offset(0, 6))]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workspace Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isAccentCard ? Colors.white.withOpacity(0.2) : surfaceSecondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isAccentCard ? Icons.workspaces_rounded : Icons.folder_open_rounded,
                          size: 16,
                          color: isAccentCard ? Colors.white : textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ws,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isAccentCard ? Colors.white : textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isAccentCard ? Colors.white.withOpacity(0.2) : surfaceSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$done/$total selesai',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isAccentCard ? Colors.white : textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: wsProgress,
                  backgroundColor: isAccentCard ? Colors.white.withOpacity(0.15) : surfaceSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isAccentCard ? Colors.white : accentColor,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 14),
              // Task Items
              ...wsTasks.map((task) => BentoTaskItem(
                    task: task,
                    onAccentBackground: isAccentCard,
                    accentColor: accentColor,
                    accentSoft: accentSoft,
                    accentLight: accentLight,
                    surfaceSecondary: surfaceSecondary,
                    cardBorder: cardBorder,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    textSecondary: textSecondary,
                    onToggle: () => onToggleTask(task),
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

