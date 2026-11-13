import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';
import 'package:alexa/features/calendar/presentation/widgets/vertical_timeline_schedule_section.dart';

class DayAgendaBottomSheet extends StatelessWidget {
  final int selectedDay;
  final String monthName;
  final int year;
  final List<CalendarEventItem> events;
  final List<Map<String, dynamic>> dueTasks;
  final VoidCallback onAddEvent;
  final ValueChanged<Map<String, dynamic>> onToggleTaskDone;

  const DayAgendaBottomSheet({
    super.key,
    required this.selectedDay,
    this.monthName = 'Oktober',
    this.year = 2026,
    required this.events,
    required this.dueTasks,
    required this.onAddEvent,
    required this.onToggleTaskDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF000000) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(
          color: isDark ? const Color(0xFF262626) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.7 : 0.15),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar Atas
            Center(
              child: Container(
                width: 40,
                height: 4.5,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Header Agenda Hari
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 6, 18, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agenda $selectedDay $monthName $year',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${events.length} Kegiatan • ${dueTasks.length} Tugas Kuliah',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quick Add Button in Sheet Header
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onAddEvent();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.12) : const Color(0xFF3B82F6).withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: isDark ? Colors.white : const Color(0xFF3B82F6),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 0.8,
              color: isDark ? const Color(0xFF262626) : const Color(0xFFF1F5F9),
            ),

            // Scrollable Timeline Schedule
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: VerticalTimelineScheduleSection(
                  selectedDay: selectedDay,
                  headerTitle: '',
                  events: events,
                  dueTasks: dueTasks,
                  onToggleTaskDone: onToggleTaskDone,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

