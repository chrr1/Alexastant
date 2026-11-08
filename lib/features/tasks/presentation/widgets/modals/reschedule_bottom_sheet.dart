import 'package:flutter/material.dart';
import 'package:alexa/features/tasks/domain/models/task_model.dart';

class RescheduleBottomSheet extends StatelessWidget {
  final TaskModel task;
  final Color accentColor;
  final Color cardBg;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color surfaceSecondary;
  final ValueChanged<DateTime> onRescheduled;

  const RescheduleBottomSheet({
    super.key,
    required this.task,
    required this.accentColor,
    required this.cardBg,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.surfaceSecondary,
    required this.onRescheduled,
  });

  static void show(
    BuildContext context, {
    required TaskModel task,
    required Color accentColor,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color surfaceSecondary,
    required ValueChanged<DateTime> onRescheduled,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => RescheduleBottomSheet(
        task: task,
        accentColor: accentColor,
        cardBg: cardBg,
        cardBorder: cardBorder,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        textMuted: textMuted,
        surfaceSecondary: surfaceSecondary,
        onRescheduled: onRescheduled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: cardBorder, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.event_repeat_rounded, color: accentColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwalkan Ulang',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                    ),
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildOption(
            context,
            icon: Icons.timer_outlined,
            title: 'Nanti Sore (+3 Jam)',
            subtitle: 'Beri jeda istirahat sebelum lanjut',
            onTap: () {
              Navigator.pop(context);
              onRescheduled(DateTime.now().add(const Duration(hours: 3)));
            },
          ),
          _buildOption(
            context,
            icon: Icons.wb_sunny_outlined,
            title: 'Besok Pagi',
            subtitle: 'Pukul 09:00 WIB',
            onTap: () {
              Navigator.pop(context);
              final tomorrow = DateTime.now().add(const Duration(days: 1));
              onRescheduled(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0));
            },
          ),
          _buildOption(
            context,
            icon: Icons.nights_stay_outlined,
            title: 'Besok Malam',
            subtitle: 'Pukul 20:00 WIB',
            onTap: () {
              Navigator.pop(context);
              final tomorrow = DateTime.now().add(const Duration(days: 1));
              onRescheduled(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 20, 0));
            },
          ),
          _buildOption(
            context,
            icon: Icons.calendar_month_outlined,
            title: 'Pilih Tanggal Kustom',
            subtitle: 'Tentukan tanggal spesifik lewat kalender',
            onTap: () async {
              Navigator.pop(context);
              final picked = await showDatePicker(
                context: context,
                initialDate: task.dueDate ?? DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: accentColor,
                        surface: cardBg,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onRescheduled(picked);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: accentColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: textMuted),
          ],
        ),
      ),
    );
  }
}

