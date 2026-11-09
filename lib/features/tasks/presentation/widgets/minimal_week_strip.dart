import 'package:flutter/material.dart';

class WeekDayItem {
  final String dayLetter;
  final int dateNumber;
  final DateTime date;

  const WeekDayItem({
    required this.dayLetter,
    required this.dateNumber,
    required this.date,
  });
}

class MinimalWeekStrip extends StatelessWidget {
  final bool isDark;
  final List<WeekDayItem> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onMonthCalendarTap;
  final String weekRangeText;

  const MinimalWeekStrip({
    super.key,
    required this.isDark,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
    required this.onMonthCalendarTap,
    this.weekRangeText = 'Aug 2-8',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header: "This week" + Interactive Month Popup Button ──────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This week',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF475569),
                  letterSpacing: -0.1,
                ),
              ),

              // Interactive Button to Open 1-Month Full Calendar
              GestureDetector(
                onTap: onMonthCalendarTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.white,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weekRangeText,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 13,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ─── 7-Day Horizontal Selector ─────────────────────────────────────
        Row(
          children: List.generate(days.length, (index) {
            final day = days[index];
            final isSelected = index == selectedIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onDaySelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: isSelected
                        ? Border.all(
                            color: isDark ? Colors.white : const Color(0xFFE2E8F0),
                            width: 1.0,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Day Letter (M, T, W, ...)
                      Text(
                        day.dayLetter,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Date Number (2, 3, 4, ...)
                      Text(
                        '${day.dateNumber}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Dot indicator
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : (isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFF94A3B8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
