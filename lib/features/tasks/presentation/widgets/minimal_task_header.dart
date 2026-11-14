import 'package:flutter/material.dart';

/// Top Header — hanya tombol Add Task (+) di pojok kanan.
class MinimalTaskHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onAddTask;

  const MinimalTaskHeader({
    super.key,
    required this.isDark,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Add Task Button (+)
        GestureDetector(
          onTap: onAddTask,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1F25)
                  : Colors.white.withOpacity(0.85),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.white,
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
      ],
    );
  }
}
