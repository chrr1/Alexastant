import 'package:flutter/material.dart';

/// Modal Bottom Sheet that renders a full 1-month calendar popup
/// allowing users to view tasks across the entire month and jump to any date.
class FullMonthCalendarModal extends StatefulWidget {
  final bool isDark;
  final DateTime initialSelectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Set<int> taskDays; // Days in the month that have tasks

  const FullMonthCalendarModal({
    super.key,
    required this.isDark,
    required this.initialSelectedDate,
    required this.onDateSelected,
    this.taskDays = const {2, 3, 4, 7, 12, 18, 24},
  });

  static Future<void> show({
    required BuildContext context,
    required bool isDark,
    required DateTime initialSelectedDate,
    required ValueChanged<DateTime> onDateSelected,
    Set<int> taskDays = const {2, 3, 4, 7, 12, 18, 24},
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FullMonthCalendarModal(
        isDark: isDark,
        initialSelectedDate: initialSelectedDate,
        onDateSelected: onDateSelected,
        taskDays: taskDays,
      ),
    );
  }

  @override
  State<FullMonthCalendarModal> createState() => _FullMonthCalendarModalState();
}

class _FullMonthCalendarModalState extends State<FullMonthCalendarModal> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  final List<String> _monthNames = const [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  final List<String> _dayNames = const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardInner = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    // Days in current displayed month
    final firstDayWeekday = _displayedMonth.weekday; // 1 = Mon, 7 = Sun
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final leadingBlanks = firstDayWeekday - 1; // blanks before 1st of month

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header Month Navigation (< Agustus 2026 >)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Row(
                children: [
                  _buildNavBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: _prevMonth,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildNavBtn(
                    icon: Icons.chevron_right_rounded,
                    onTap: _nextMonth,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Days of Week Header (Sen, Sel, Rab, Kam, Jum, Sab, Min)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dayNames.map((day) {
              return SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textMuted,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Calendar Grid (Leading blanks + days)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingBlanks + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 4,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (ctx, index) {
              if (index < leadingBlanks) {
                return const SizedBox.shrink();
              }

              final dayNumber = index - leadingBlanks + 1;
              final currentDate = DateTime(_displayedMonth.year, _displayedMonth.month, dayNumber);
              final isSelected = currentDate.year == _selectedDate.year &&
                  currentDate.month == _selectedDate.month &&
                  currentDate.day == _selectedDate.day;
              final hasTask = widget.taskDays.contains(dayNumber);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = currentDate;
                  });
                  widget.onDateSelected(currentDate);
                  Navigator.pop(context);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFF0F172A))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Dot indicator for tasks
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white
                              : (hasTask
                                  ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFF50689C))
                                  : Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Quick Action / Today Shortcut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  final now = DateTime.now();
                  widget.onDateSelected(now);
                  Navigator.pop(context);
                },
                child: Text(
                  'Hari Ini',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF50689C),
                  ),
                ),
              ),
              Text(
                '${widget.taskDays.length} hari dengan tugas',
                style: TextStyle(
                  fontSize: 12,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }
}

