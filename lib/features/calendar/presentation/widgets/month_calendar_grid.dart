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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.cardBorder),
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrangeSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${monthEvents.values.fold(0, (sum, list) => sum + list.length)} Kegiatan',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrangeLight,
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
                      color: AppColors.textMuted,
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
                        ? AppColors.primaryOrange
                        : (hasEvents
                            ? AppColors.surfaceSecondary
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : (hasEvents
                              ? AppColors.primaryOrange.withOpacity(0.25)
                              : AppColors.cardBorder),
                    ),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: AppColors.primaryOrangeGlow,
                              blurRadius: 12,
                              offset: Offset(0, 4),
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
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary),
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

          const SizedBox(height: 12),

          // Legenda Warna Penanda Kegiatan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppColors.primaryOrange, 'Rapat/Workspace'),
              const SizedBox(width: 14),
              _buildLegendItem(AppColors.success, 'Tugas/Selesai'),
              const SizedBox(width: 14),
              _buildLegendItem(AppColors.purple, 'Project/Pribadi'),
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
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
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
            fontSize: 9,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

