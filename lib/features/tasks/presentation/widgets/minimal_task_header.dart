import 'package:flutter/material.dart';

/// Top Header matching the reference design:
/// - Light mode: "Today", "Wed, Aug 4" with a rounded tune/filter button on the right.
/// - Dark mode: "Today", "Wed, Aug 4" (in blue) with a circular progress ring badge (35%) on the right.
class MinimalTaskHeader extends StatelessWidget {
  final bool isDark;
  final String dateText;
  final int progressPercent;
  final VoidCallback onActionTap;
  final VoidCallback onAddTask;

  const MinimalTaskHeader({
    super.key,
    required this.isDark,
    this.dateText = 'Wed, Aug 4',
    this.progressPercent = 35,
    required this.onActionTap,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Today + Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF94A3B8) : Colors.white.withOpacity(0.85),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF3B82F6) : Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),

        // Add Task Button (+)
        GestureDetector(
          onTap: onAddTask,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : Colors.white.withOpacity(0.85),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.12) : Colors.white,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.20 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              size: 22,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Right Widget:
        // - In Light Mode: sleek tune / filter glass button
        // - In Dark Mode: 35% Overall progress circular gauge ring
        if (!isDark)
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        else
          GestureDetector(
            onTap: onActionTap,
            child: SizedBox(
              width: 58,
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Progress Arc
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: progressPercent / 100.0,
                      strokeWidth: 2.2,
                      backgroundColor: const Color(0xFF1E293B),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                    ),
                  ),
                  // Centered text inside ring
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$progressPercent%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Overall\nprogress',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF94A3B8),
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

