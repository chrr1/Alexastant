import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';

/// Grid Kalender Bulanan ala Samsung One UI Full-Screen
class SamsungMonthGrid extends StatelessWidget {
  final DateTime currentMonth; // Default: Oktober 2026
  final int selectedDay;
  final Map<int, List<CalendarEventItem>> events;
  final ValueChanged<int> onDaySelected;
  final bool? isDark;

  const SamsungMonthGrid({
    super.key,
    required this.currentMonth,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Sinkronisasi mutlak dengan ThemeController
    final dark = isDark ?? ThemeController.instance.isDarkMode;

    // Header Nama Hari: MIN (merah), SEN, SEL, RAB, KAM, JUM, SAB
    const daysOfWeek = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];

    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final daysInPrevMonth = DateTime(currentMonth.year, currentMonth.month, 0).day;

    // Kolom 0 = Minggu
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final totalCells = (firstWeekday + daysInMonth <= 35) ? 35 : 42;
    final rowCount = totalCells ~/ 7;

    return Column(
      children: [
        // ─── Header Baris Hari (MIN SEN SEL RAB KAM JUM SAB) ───────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
          child: Row(
            children: List.generate(7, (colIndex) {
              final isSunday = colIndex == 0;
              return Expanded(
                child: Center(
                  child: Text(
                    daysOfWeek[colIndex],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSunday
                          ? const Color(0xFFEF4444) // Merah untuk Hari Minggu
                          : (dark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Garis Pembatas Header Tipis
        Divider(
          height: 1,
          thickness: 0.8,
          color: dark ? const Color(0xFF262626) : const Color(0xFFE2E8F0),
        ),

        // ─── Grid Baris Minggu (Full-Screen Expanded Rows) ─────────────────
        Expanded(
          child: Column(
            children: List.generate(rowCount, (rowIndex) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: dark ? const Color(0xFF262626) : const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Row(
                    children: List.generate(7, (colIndex) {
                      final cellIndex = (rowIndex * 7) + colIndex;
                      final dayNum = cellIndex - firstWeekday + 1;

                      final bool isCurrentMonth = dayNum >= 1 && dayNum <= daysInMonth;
                      final bool isSunday = colIndex == 0;
                      final bool isSelected = isCurrentMonth && dayNum == selectedDay;

                      int displayDay;
                      if (dayNum < 1) {
                        displayDay = daysInPrevMonth + dayNum;
                      } else if (dayNum > daysInMonth) {
                        displayDay = dayNum - daysInMonth;
                      } else {
                        displayDay = dayNum;
                      }

                      final dayEvents = isCurrentMonth ? (events[dayNum] ?? []) : <CalendarEventItem>[];

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isCurrentMonth) {
                              onDaySelected(dayNum);
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.5),
                            decoration: BoxDecoration(
                              // Outline Rounded Rectangle Khas Tanggal Terpilih Samsung
                              border: isSelected
                                  ? Border.all(
                                      color: dark ? Colors.white : const Color(0xFF0F172A),
                                      width: 1.6,
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Nomor Tanggal (Putih murni di mode gelap!)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                                  child: Text(
                                    '$displayDay',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: !isCurrentMonth
                                          ? (dark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1))
                                          : isSunday
                                              ? const Color(0xFFEF4444) // Merah hari Minggu
                                              : (dark ? Colors.white : const Color(0xFF0F172A)),
                                    ),
                                  ),
                                ),

                                // Tumpukan Event Pill Cards
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final maxPills = (constraints.maxHeight / 19).floor();
                                        final displayCount = dayEvents.length > maxPills ? maxPills : dayEvents.length;

                                        return Column(
                                          children: [
                                            for (int i = 0; i < displayCount; i++)
                                              _buildEventPill(dayEvents[i]),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Event Pill Mini ala Samsung One UI (Teks & Icon Putih Bersih)
  Widget _buildEventPill(CalendarEventItem event) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 1.5),
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.92),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon lonceng warna putih
          const Icon(
            Icons.notifications_rounded,
            size: 7.5,
            color: Colors.white,
          ),
          const SizedBox(width: 1.5),
          // Judul acara warna putih murni sesuai permintaan pengguna
          Expanded(
            child: Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8.2,
                fontWeight: FontWeight.w700,
                color: Colors.white, // Tulisan putih bersih
                height: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
