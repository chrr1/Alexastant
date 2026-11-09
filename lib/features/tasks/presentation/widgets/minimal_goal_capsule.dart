import 'package:flutter/material.dart';

/// Floating capsule pill matching the bottom "I want to become..." in the design reference.
class MinimalGoalCapsule extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  final String text;

  const MinimalGoalCapsule({
    super.key,
    required this.isDark,
    required this.onTap,
    this.text = 'I want to become...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.10)
                : Colors.white.withOpacity(0.90), // High opacity milky glass
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.18)
                  : Colors.white,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF334155), // High contrast deep slate
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}
