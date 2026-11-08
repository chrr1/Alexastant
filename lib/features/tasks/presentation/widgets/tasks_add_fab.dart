import 'package:flutter/material.dart';

class TasksAddFab extends StatelessWidget {
  final LinearGradient accentGradient;
  final Color accentGlow;
  final VoidCallback onTap;

  const TasksAddFab({
    super.key,
    required this.accentGradient,
    required this.accentGlow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 84.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: accentGradient,
            boxShadow: [
              BoxShadow(
                color: accentGlow,
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
