import 'package:flutter/material.dart';

class CognitiveLoadCard extends StatelessWidget {
  final Color cardBg;
  final Color cardBorder;
  final Color cardInnerBg;
  final Color textPrimary;
  final Color textMuted;
  final Color accentColor;
  final double animProgress;

  const CognitiveLoadCard({
    super.key,
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
    final unfilledBarColor = Color.lerp(
      const Color(0xFF22222A),
      const Color(0xFFE2E8F0),
      animProgress,
    )!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18 - (animProgress * 0.14)),
            blurRadius: 12,
            offset: const Offset(0, 3),
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
                'Beban Mental Hari Ini',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: -0.1,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '65%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• Terkendali',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 5-segment energy bar
          Row(
            children: List.generate(5, (index) {
              final isFilled = index < 3;
              final isCurrent = index == 3;
              return Expanded(
                child: Container(
                  height: 10,
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? accentColor
                        : (isCurrent
                            ? accentColor.withOpacity(0.35)
                            : unfilledBarColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          // Micro-breakdown badges
          Row(
            children: [
              _buildLoadBadge(
                Icons.school_outlined,
                '2 Sesi Kuliah',
                '3.5 jam',
                cardInnerBg: cardInnerBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              const SizedBox(width: 8),
              _buildLoadBadge(
                Icons.assignment_outlined,
                '2 Tugas',
                'Sore ini',
                cardInnerBg: cardInnerBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              const SizedBox(width: 8),
              _buildLoadBadge(
                Icons.battery_charging_full_rounded,
                'Kapasitas',
                '35% luang',
                cardInnerBg: cardInnerBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadBadge(
    IconData icon,
    String title,
    String sub, {
    required Color cardInnerBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: cardInnerBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 25, color: textMuted),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            Text(
              sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

