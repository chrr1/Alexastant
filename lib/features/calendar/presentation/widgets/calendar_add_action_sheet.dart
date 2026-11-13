import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';

enum CalendarAddOption {
  reminder,
  scheduleEvent,
}

class CalendarAddActionSheet extends StatelessWidget {
  final int selectedDay;
  final String monthName;
  final ValueChanged<CalendarAddOption> onOptionSelected;

  const CalendarAddActionSheet({
    super.key,
    required this.selectedDay,
    this.monthName = 'Okt',
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF000000) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark ? const Color(0xFF262626) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.7 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 38,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Header Title
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah ke $selectedDay $monthName',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pilih jenis agenda yang ingin kamu buat:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Opsi 1: Pengingat Baru (Reminder)
            _buildActionTile(
              icon: Icons.notifications_active_rounded,
              iconBg: isDark ? Colors.white.withOpacity(0.10) : const Color(0xFF3B82F6).withOpacity(0.14),
              iconColor: isDark ? Colors.white : const Color(0xFF3B82F6),
              title: 'Pengingat Baru',
              subtitle: 'Atur alarm waktu, perulangan, dan kategori pengingat',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                onOptionSelected(CalendarAddOption.reminder);
              },
            ),

            const SizedBox(height: 10),

            // Opsi 2: Acara / Jadwal Kalender (Schedule)
            _buildActionTile(
              icon: Icons.event_note_rounded,
              iconBg: isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFF59E0B).withOpacity(0.14),
              iconColor: isDark ? Colors.white : const Color(0xFFF59E0B),
              title: 'Jadwal Acara / Kuliah',
              subtitle: 'Agenda perkuliahan atau rapat dengan rentang waktu',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                onOptionSelected(CalendarAddOption.scheduleEvent);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161616) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFE2E8F0),
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
