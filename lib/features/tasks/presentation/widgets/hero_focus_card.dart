import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/task_model.dart';

class HeroFocusCard extends StatelessWidget {
  final TaskModel task;
  final double t;
  final Color accentColor;
  final LinearGradient accentGradient;
  final Color cardBorder;
  final Color textPrimary;
  final Color textMuted;
  final Color surfaceSecondary;
  final Color cardInnerBg;
  final VoidCallback onReschedule;
  final VoidCallback onToggleComplete;

  const HeroFocusCard({
    super.key,
    required this.task,
    required this.t,
    required this.accentColor,
    required this.accentGradient,
    required this.cardBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.surfaceSecondary,
    required this.cardInnerBg,
    required this.onReschedule,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.completed;

    final heroBg1 = Color.lerp(const Color(0xFF1F1F26), const Color(0xFFFFFFFF), t)!;
    final heroBg2 = Color.lerp(const Color(0xFF16161C), const Color(0xFFF8FAFC), t)!;
    final heroBorder = Color.lerp(Colors.white.withOpacity(0.4), const Color(0xFFDCE4EE), t)!;
    final heroChipBg = Color.lerp(Colors.white.withOpacity(0.15), const Color(0xFF0A84FF).withOpacity(0.1), t)!;
    final heroChipText = Color.lerp(Colors.white, const Color(0xFF0F172A), t)!;
    final heroDescColor = Color.lerp(Colors.white, const Color(0xFF475569), t)!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [heroBg1, heroBg2],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: heroBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: heroChipBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: heroChipText),
                    const SizedBox(width: 4),
                    Text(
                      'FOKUS UTAMA HARI INI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: heroChipText,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: heroChipBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sisa 1 jam lagi',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: heroChipText,
                  ),
                ),
              ),
            ],
          ),
          if (task.matkul != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: heroChipBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded, color: heroChipText, size: 11),
                  const SizedBox(width: 4),
                  Text(
                    task.matkul!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: heroChipText,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDone ? textMuted : textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              height: 1.3,
            ),
          ),
          if (task.description != null) ...[
            const SizedBox(height: 6),
            Text(
              task.description!,
              style: TextStyle(fontSize: 11, color: heroDescColor, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub-tugas (${task.subtasksDone}/${task.subtasksTotal})',
                          style: TextStyle(fontSize: 10, color: textMuted),
                        ),
                        Text(
                          '${((task.subtasksDone / (task.subtasksTotal > 0 ? task.subtasksTotal : 1)) * 100).toInt()}%',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: task.subtasksTotal > 0 ? (task.subtasksDone / task.subtasksTotal) : 0,
                        backgroundColor: Colors.black.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onReschedule,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.lerp(AppColors.surfaceSecondary, const Color(0xFFF1F5F9), t),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_repeat_rounded, size: 16, color: textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          'Jadwalkan Ulang',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onToggleComplete,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isDone ? null : accentGradient,
                    color: isDone ? AppColors.success : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(isDone ? Icons.check : Icons.check_circle_outline, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        isDone ? 'Selesai' : 'Tandai Selesai',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

