import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';

class MonthCalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final int selectedDay;
  final Map<int, List<CalendarEventItem>> monthEvents;
  final ValueChanged<int> onDaySelected;

  const MonthCalendarGrid({
    super.key,
    required this.currentMonth,
    required this.selectedDay,
    required this.monthEvents,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final monthTitle = '${monthNames[currentMonth.month - 1]} ${currentMonth.year}';
    final daysOfWeek = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    // Juni 2026 dimulai pada hari Senin (weekday = 1), memiliki 30 hari
    const totalDays = 30;
    const startWeekdayOffset = 0; // 0 padding jika tanggal 1 adalah Senin

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Bulan dengan Panah Navigasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    monthTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${monthEvents.values.fold(0, (sum, list) => sum + list.length)} Kegiatan',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildMonthNavButton(Icons.chevron_left_rounded, () {
                    // Previous month
                  }),
                  const SizedBox(width: 6),
                  _buildMonthNavButton(Icons.chevron_right_rounded, () {
                    // Next month
                  }),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Baris Nama Hari (Sen - Min)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: daysOfWeek.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Grid Tanggal 7 Kolom x 5 Baris
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalDays + startWeekdayOffset,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 6,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekdayOffset) {
                return const SizedBox.shrink();
              }

              final dayNumber = index - startWeekdayOffset + 1;
              final isSelected = dayNumber == selectedDay;
              final eventsForDay = monthEvents[dayNumber] ?? [];
              final hasEvents = eventsForDay.isNotEmpty;

              return GestureDetector(
                onTap: () => onDaySelected(dayNumber),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : (hasEvents
                            ? const Color(0xFFF8FAFC)
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (hasEvents
                              ? const Color(0xFFCBD5E1)
                              : Colors.transparent),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (hasEvents
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFF94A3B8)),
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Tanda Kegiatan (Colored Dots)
                      if (hasEvents)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: eventsForDay.take(3).map((event) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.2),
                              width: 4.5,
                              height: 4.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.white
                                    : event.color,
                              ),
                            );
                          }).toList(),
                        )
                      else
                        const SizedBox(height: 4.5),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          // Legenda Warna Penanda Kegiatan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(const Color(0xFF2563EB), 'Rapat/Workspace'),
              const SizedBox(width: 14),
              _buildLegendItem(const Color(0xFF10B981), 'Tugas/Selesai'),
              const SizedBox(width: 14),
              _buildLegendItem(const Color(0xFF8B5CF6), 'Project/Pribadi'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF334155)),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

