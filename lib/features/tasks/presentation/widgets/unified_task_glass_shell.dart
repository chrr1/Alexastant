import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';
import 'minimal_week_strip.dart';
import 'stacked_task_cards_slider.dart';

/// Unified Frosted Glass Monolith Shell
/// Wraps:
/// 1. Overall progress (top)
/// 2. Stacked Task Cards Slider (middle) with Subtasks Checklist & Deadline
/// 3. This Week 7-Day Calendar Strip (bottom)
/// all inside one continuous curved milky glass panel.
class UnifiedTaskGlassShell extends StatelessWidget {
  final bool isDark;
  final List<TaskModel> tasks;
  final int progressPercent;
  final List<WeekDayItem> weekDays;
  final int selectedDayIndex;
  final String weekRangeText;
  final ValueChanged<TaskModel> onToggleTaskComplete;
  final Function(TaskModel task, SubtaskItem subtask) onToggleSubtask;
  final ValueChanged<TaskModel> onEditTask;
  final VoidCallback onMonthCalendarTap;
  final ValueChanged<int> onDaySelected;

  const UnifiedTaskGlassShell({
    super.key,
    required this.isDark,
    required this.tasks,
    this.progressPercent = 35,
    required this.weekDays,
    required this.selectedDayIndex,
    required this.weekRangeText,
    required this.onToggleTaskComplete,
    required this.onToggleSubtask,
    required this.onEditTask,
    required this.onMonthCalendarTap,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final overallProgressTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final overallProgressSubTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final ringBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1);
    final ringValueColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.92),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.30)
                : const Color(0xFF334A66).withOpacity(0.10),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── 1. Overall Progress Header Row ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    value: progressPercent / 100.0,
                    strokeWidth: 2.2,
                    backgroundColor: ringBgColor,
                    valueColor: AlwaysStoppedAnimation<Color>(ringValueColor),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Overall progress',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: overallProgressSubTextColor,
                    letterSpacing: -0.1,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: overallProgressTextColor,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ─── 2. Stacked Task Cards Slider ─────────────────────────────────
          // Front card with Subtasks & Deadline, back card peeking out with swipe gesture!
          StackedTaskCardsSlider(
            isDark: isDark,
            tasks: tasks,
            onToggleTaskComplete: onToggleTaskComplete,
            onToggleSubtask: onToggleSubtask,
            onEditTask: onEditTask,
          ),

          const SizedBox(height: 20),

          // Divider subtle line
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: isDark
                ? Colors.white.withOpacity(0.10)
                : const Color(0xFFCBD5E1).withOpacity(0.6),
          ),

          const SizedBox(height: 16),

          // ─── 3. Weekly Strip (Inside the Glass Shell) ─────────────────────
          MinimalWeekStrip(
            isDark: isDark,
            days: weekDays,
            selectedIndex: selectedDayIndex,
            weekRangeText: weekRangeText,
            onMonthCalendarTap: onMonthCalendarTap,
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }
}
