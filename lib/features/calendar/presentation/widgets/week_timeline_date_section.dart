import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';

class WeekTimelineDateSection extends StatelessWidget {
  final int selectedDay;
  final List<Map<String, dynamic>> weekDays;
  final ValueChanged<int> onDaySelected;

  const WeekTimelineDateSection({
    super.key,
    required this.selectedDay,
    required this.weekDays,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── 1. Subtitle Date & Header Title ────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'May $selectedDay, 2026',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Today',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ─── 2. Ultra-Clean 7-Day Week Strip (Reference Design) ────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B).withOpacity(0.6) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(isDark ? 0.20 : 0.03),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((item) {
              final isSelected = item['num'] == '$selectedDay';
              final dayNum = item['num'] as String;
              final dayName = item['day'] as String;

              return GestureDetector(
                onTap: () {
                  onDaySelected(int.parse(dayNum));
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Day Abbreviation (Mon, Tue, ...)
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Day Number (4, 5, 6, ...)
                      Text(
                        dayNum,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : (isDark ? Colors.white : const Color(0xFF1E293B)),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Selection Dot Indicator below active day
                      Container(
                        width: 4.5,
                        height: 4.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

