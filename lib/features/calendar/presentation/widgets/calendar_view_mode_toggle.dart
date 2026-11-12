import 'package:flutter/material.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';

class CalendarViewModeToggle extends StatelessWidget {
  final CalendarViewMode viewMode;
  final ValueChanged<CalendarViewMode> onChanged;

  const CalendarViewModeToggle({
    super.key,
    required this.viewMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          _buildToggleOption(
            title: 'Bulanan (30 Hari)',
            mode: CalendarViewMode.month,
            icon: Icons.calendar_view_month_rounded,
          ),
          _buildToggleOption(
            title: 'Mingguan (Timeline)',
            mode: CalendarViewMode.week,
            icon: Icons.calendar_view_week_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required CalendarViewMode mode,
    required IconData icon,
  }) {
    final isSelected = viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(mode),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

