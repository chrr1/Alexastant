import 'package:flutter/material.dart';

class EditorialHeader extends StatelessWidget {
  final Color textPrimary;
  final Color textMuted;

  const EditorialHeader({
    super.key,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hari Ini',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textMuted,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '02 November',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ritme belajar optimal • 3 sesi tersisa hari ini',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textMuted,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

