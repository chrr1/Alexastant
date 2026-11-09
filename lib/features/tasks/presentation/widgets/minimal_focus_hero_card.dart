import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';

class MinimalFocusHeroCard extends StatelessWidget {
  final bool isDark;
  final TaskModel focusTask;
  final TaskModel? nextUpTask;
  final int progressPercent;
  final VoidCallback onStartTask;
  final VoidCallback onNextUpTap;
  final VoidCallback onToggleComplete;

  const MinimalFocusHeroCard({
    super.key,
    required this.isDark,
    required this.focusTask,
    this.nextUpTask,
    this.progressPercent = 35,
    required this.onStartTask,
    required this.onNextUpTap,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Priority chip styling
    Color priorityColor;
    String priorityLabel;
    switch (focusTask.priority) {
      case TaskPriority.urgent:
        priorityColor = const Color(0xFFEF4444);
        priorityLabel = 'Urgent';
        break;
      case TaskPriority.high:
        priorityColor = const Color(0xFFF97316);
        priorityLabel = 'High';
        break;
      case TaskPriority.medium:
        priorityColor = const Color(0xFF3B82F6);
        priorityLabel = 'Medium';
        break;
      case TaskPriority.low:
        priorityColor = const Color(0xFF10B981);
        priorityLabel = 'Low';
        break;
    }

    // Format due time (e.g. "17:00" or from dueDate)
    final dueTimeString = focusTask.dueDate != null
        ? '${focusTask.dueDate!.hour.toString().padLeft(2, '0')}:${focusTask.dueDate!.minute.toString().padLeft(2, '0')}'
        : '17:00';

    final categoryLabel = focusTask.matkul ?? focusTask.workspace;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── 1. Overall Progress Pill (Visible in Light Mode) ───────────────
        if (!isDark) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Mini circular arc icon
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    value: progressPercent / 100.0,
                    strokeWidth: 2.0,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Overall progress',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: -0.1,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progressPercent%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // ─── 2. Stacked Cards: Main Focus White Card + Next Up Peek ─────────
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF324666).withOpacity(0.16),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
          ),
          child: Column(
            children: [
              // ─── The Main Focus Card (Pure White Surface) ─────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Category + Priority + Checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: "Today's focus • Matkul" + Priority Chip
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                "Today's focus",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                  letterSpacing: -0.1,
                                ),
                              ),
                              if (categoryLabel.isNotEmpty) ...[
                                const Text(
                                  "•",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                Text(
                                  categoryLabel,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                              // Priority Chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  priorityLabel,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: priorityColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right: Interactive Checkbox (Mark as Completed)
                        GestureDetector(
                          onTap: onToggleComplete,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: focusTask.status == TaskStatus.completed
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF1F5F9),
                              border: Border.all(
                                color: focusTask.status == TaskStatus.completed
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFCBD5E1),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              focusTask.status == TaskStatus.completed
                                  ? Icons.check_rounded
                                  : Icons.check_rounded,
                              size: 18,
                              color: focusTask.status == TaskStatus.completed
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Main Title
                    Text(
                      focusTask.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Description
                    Text(
                      focusTask.description ??
                          'Pelajari materi inti, kerjakan latihan pemahaman, dan lengkapi tugas di lembar kerja.',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                        height: 1.45,
                        letterSpacing: -0.1,
                      ),
                    ),

                    // Subtasks progress line if available
                    if (focusTask.subtasksTotal > 0) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: focusTask.subtasksDone / focusTask.subtasksTotal,
                                minHeight: 4,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF50689C)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${focusTask.subtasksDone}/${focusTask.subtasksTotal} subtasks',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Bottom Action Row
                    if (!isDark)
                      // Light Mode CTA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Start Task Pill Button
                          GestureDetector(
                            onTap: onStartTask,
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF0000),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Start task',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Duration + Due Time
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 15,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${focusTask.estimatedHours}h',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFCBD5E1),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.notifications_none_rounded,
                                size: 15,
                                color: Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dueTimeString,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      // Dark Mode CTA
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: onStartTask,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Start task  ${focusTask.estimatedHours}h  •  Due $dueTimeString',
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // ─── "Next Up" Shelf Card (Stacked Underneath) ────────────────
              if (nextUpTask != null)
                GestureDetector(
                  onTap: onNextUpTap,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.white.withOpacity(0.22),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.35),
                          width: 1.0,
                        ),
                        left: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.35),
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.35),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Next Up',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : Colors.white.withOpacity(0.9),
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nextUpTask!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFE2E8F0)
                                  : Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
