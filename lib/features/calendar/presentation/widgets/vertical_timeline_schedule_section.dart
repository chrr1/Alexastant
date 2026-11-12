import 'package:flutter/material.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';

class TimelineEventModel {
  final String id;
  final String title;
  final String time;
  final String description;
  final bool isActive;
  final List<String>? avatarInitials;

  TimelineEventModel({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    this.isActive = false,
    this.avatarInitials,
  });
}

/// Vertical Connected Timeline Schedule Section:
/// Recreated to match the reference design:
/// - Left continuous timeline track with circular node indicators (concentric dual-ring for active item).
/// - Right event cards:
///   - Normal: Soft clean off-white card with title, time, and description.
///   - Active: Vibrant royal blue hero card with white text, overlapping avatar stack, and action squircle.
/// - Flexible: Can be used in both Weekly and Monthly views with dynamic events & tasks.
class VerticalTimelineScheduleSection extends StatelessWidget {
  final int selectedDay;
  final String? headerTitle;
  final String? headerSubtitle;
  final List<CalendarEventItem>? events;
  final List<Map<String, dynamic>>? dueTasks;
  final void Function(Map<String, dynamic> task)? onToggleTaskDone;
  final ValueChanged<String>? onEventTap;

  const VerticalTimelineScheduleSection({
    super.key,
    required this.selectedDay,
    this.headerTitle,
    this.headerSubtitle,
    this.events,
    this.dueTasks,
    this.onToggleTaskDone,
    this.onEventTap,
  });

  List<TimelineEventModel> _getEventsForDay(int day) {
    // Jika ada events custom yang di-pass (misal dari mode bulanan per tanggal)
    if (events != null) {
      if (events!.isEmpty) return [];

      return events!.asMap().entries.map((entry) {
        final index = entry.key;
        final e = entry.value;
        final isHeroActive = index == 0; // Item pertama menjadi hero active card
        final hasTeam = e.category.toLowerCase().contains('rapat') ||
            e.title.toLowerCase().contains('proyek') ||
            e.title.toLowerCase().contains('team');

        return TimelineEventModel(
          id: e.id,
          title: e.title,
          time: e.time,
          description: '${e.location} • ${e.category} (${e.duration})',
          isActive: isHeroActive,
          avatarInitials: hasTeam ? ['RI', 'AM', 'BD'] : null,
        );
      }).toList();
    }

    // Default mock data untuk mode mingguan
    return [
      TimelineEventModel(
        id: 't_wake',
        title: 'Wakeup',
        time: '7:00 AM',
        description: 'Early wakeup from bed and fresh',
        isActive: false,
      ),
      TimelineEventModel(
        id: 't_exercise',
        title: 'Morning Excercise',
        time: '8:00 AM',
        description: '4 types of exercise, stretching & light cardio',
        isActive: false,
      ),
      TimelineEventModel(
        id: 't_meeting',
        title: 'Meeting & Kuliah RPL',
        time: '9:00 AM',
        description: 'Zoom call, Discuss team task and system design architecture for the day',
        isActive: true, // Active highlight card matching reference image
        avatarInitials: ['RI', 'AM', 'BD', 'NA'],
      ),
      TimelineEventModel(
        id: 't_breakfast',
        title: 'Breakfast & Study',
        time: '10:00 AM',
        description: 'Morning breakfast with bread, banana egg bowl and review lecture notes',
        isActive: false,
      ),
      TimelineEventModel(
        id: 't_database',
        title: 'Praktikum Basis Data',
        time: '13:00 PM',
        description: 'Lab Komputer 3, implementasi normalisasi 3NF & query PostgreSQL',
        isActive: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timelineEvents = _getEventsForDay(selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header Opsional (Terutama untuk Mode Bulanan) ─────────────────
        if (headerTitle != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headerSubtitle ?? 'Juni 2026',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    headerTitle!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  events != null
                      ? (events!.isEmpty ? '0 Agenda' : '${events!.length} Agenda')
                      : 'Jadwal Hari Ini',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
        ],

        // ─── Tampilan Jika Agenda Kosong ────────────────────────────────────
        if (timelineEvents.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(isDark ? 0.20 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bebas Agenda di Tanggal $selectedDay',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tidak ada kegiatan terjadwal — waktu yang baik untuk istirahat atau fokus belajar mandiri.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          )
        else
          // ─── Connected Vertical Timeline List ────────────────────────────
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: timelineEvents.length,
            itemBuilder: (context, index) {
              final event = timelineEvents[index];
              final isFirst = index == 0;
              final isLast = index == timelineEvents.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── 1. Left Vertical Timeline Track ─────────────────────
                    SizedBox(
                      width: 34,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Vertical Connecting Line
                          Positioned(
                            top: isFirst ? 18 : 0,
                            bottom: isLast ? 0 : 0,
                            left: 15,
                            child: Container(
                              width: 2,
                              color: const Color(0xFF60A5FA).withOpacity(isDark ? 0.40 : 0.45),
                            ),
                          ),

                          // Node Circle
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: event.isActive
                                ? Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFF2563EB),
                                        width: 2.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB).withOpacity(0.35),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF2563EB),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFF60A5FA),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ─── 2. Right Event Card ────────────────────────────────
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GestureDetector(
                          onTap: () => onEventTap?.call(event.id),
                          child: event.isActive
                              ? _buildActiveCard(event, isDark)
                              : _buildNormalCard(event, isDark),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

        // ─── 3. Due Tasks Integration (Jika Ada) ───────────────────────────
        if (dueTasks != null && dueTasks!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildDueTasksCard(dueTasks!, onToggleTaskDone, isDark),
        ],
      ],
    );
  }

  // ─── DUE TASKS CARD INTEGRATION ───────────────────────────────────────────
  Widget _buildDueTasksCard(
    List<Map<String, dynamic>> tasks,
    void Function(Map<String, dynamic>)? onToggle,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(isDark ? 0.20 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Color(0xFF2563EB),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tugas Jatuh Tempo (${tasks.length})',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const Text(
                        'Terhubung dari Halaman Tasks',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${tasks.where((t) => t['isDone'] == true).length}/${tasks.length} Selesai',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) {
            final isDone = task['isDone'] == true;
            return GestureDetector(
              onTap: () => onToggle?.call(task),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isDone ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task['title'] as String,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDone
                              ? const Color(0xFF94A3B8)
                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task['matkul'] != null
                            ? '📚 ${task['matkul']}'
                            : task['workspace'] as String,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── ACTIVE HERO CARD (Vibrant Royal Blue) ───────────────────────────────────
  Widget _buildActiveCard(TimelineEventModel event, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6), // Vibrant primary blue
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.38),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                event.time,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.90),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Description
          Text(
            event.description,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.88),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          // Bottom Row: Overlapping Avatars & White Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Overlapping Avatar Stack
              _buildAvatarStack(event.avatarInitials ?? ['RI', 'AM', 'BD']),

              // White Action Squircle Button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.bubble_chart_rounded,
                    size: 19,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── NORMAL EVENT CARD (Clean Minimalist Off-White) ─────────────────────────
  Widget _buildNormalCard(TimelineEventModel event, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(isDark ? 0.20 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                event.time,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Description
          Text(
            event.description,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ─── OVERLAPPING AVATAR STACK ───────────────────────────────────────────────
  Widget _buildAvatarStack(List<String> initials) {
    final avatarColors = [
      const Color(0xFFF97316),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFEC4899),
    ];

    return SizedBox(
      height: 30,
      width: (initials.length * 20.0) + 12,
      child: Stack(
        children: List.generate(initials.length, (i) {
          return Positioned(
            left: i * 18.0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColors[i % avatarColors.length],
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials[i],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

