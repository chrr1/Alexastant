import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';

class NotesAddFab extends StatelessWidget {
  final VoidCallback onTap;

  const NotesAddFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 84.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.orangeGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrangeGlow,
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
