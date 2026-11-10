import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/today_task_item.dart';

class TodayPriorityTasksCard extends StatelessWidget {
  final List<TodayTaskItem> tasks;
  final ValueChanged<TodayTaskItem> onToggleTask;
  final Color cardBg;
  final Color cardBorder;
  final Color cardInnerBg;
  final Color textPrimary;
  final Color textMuted;
  final Color accentColor;
  final double animProgress;

  const TodayPriorityTasksCard({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.cardBg,
    required this.cardBorder,
    required this.cardInnerBg,
    required this.textPrimary,
    required this.textMuted,
    required this.accentColor,
    required this.animProgress,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((t) => t.isCompleted).length;

    final uncheckedBorder = Color.lerp(
      const Color(0xFF52525B),
      const Color(0xFF8A99AD),
      animProgress,
    )!;

    final doneItemBg = Color.lerp(
      const Color(0xFF181820).withOpacity(0.5),
      Colors.white.withOpacity(0.25),
      animProgress,
    )!;

    final doneTextColor = Color.lerp(
      const Color(0xFF52525B),
      const Color(0xFF8A99AD),
      animProgress,
    )!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  cardBg,
                  Colors.white.withOpacity(0.95),
                  animProgress,
                )!,
                Color.lerp(
                  cardBg,
                  Colors.white.withOpacity(0.80),
                  animProgress,
                )!,
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Color.lerp(
                cardBorder,
                Colors.white.withOpacity(0.80),
                animProgress,
              )!,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(animProgress > 0.5 ? 0.07 : 0.20),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prioritas Hari Ini',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardInnerBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completedCount / ${tasks.length} selesai',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...tasks.map((task) {
                final isDone = task.isCompleted;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onToggleTask(task),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDone ? doneItemBg : cardInnerBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDone ? Colors.transparent : cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Interactive Checkbox Pill
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isDone ? accentColor : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDone ? accentColor : uncheckedBorder,
                              width: 1.8,
                            ),
                          ),
                          child: isDone
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
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
                                  fontWeight: FontWeight.w600,
                                  color: isDone ? doneTextColor : textPrimary,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: doneTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        AppColors.primaryOrange.withOpacity(0.8),
                                        accentColor,
                                        animProgress,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      task.matkul,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tenggat ${task.due}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
  }
}
