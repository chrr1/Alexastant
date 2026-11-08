import 'package:flutter/material.dart';

class TasksSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final Color cardBg;
  final Color cardBorder;
  final Color textPrimary;
  final Color textMuted;
  final Color textSecondary;

  const TasksSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.cardBg,
    required this.cardBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: textMuted, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari tugas, tag, atau workspace...',
                hintStyle: TextStyle(color: textMuted, fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close_rounded, color: textSecondary, size: 18),
            ),
        ],
      ),
    );
  }
}

