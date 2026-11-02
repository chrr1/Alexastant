import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'manage_timeline_screen.dart';
import 'new_task_form_screen.dart';

enum CalendarViewMode { month, week }

class CalendarEventItem {
  final String id;
  final String title;
  final String time;
  final String duration;
  final String location;
  final Color color;
  final String category;
  final bool isCompleted;

  CalendarEventItem({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    required this.location,
    required this.color,
    required this.category,
    this.isCompleted = false,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarViewMode _viewMode = CalendarViewMode.month;
  DateTime _currentMonth = DateTime(2026, 6, 1);
  int _selectedDay = 4; // 4 June 2026 default

  // Data kegiatan per tanggal untuk penanda titik (dots) dan agenda detail
  final Map<int, List<CalendarEventItem>> _monthEvents = {
    2: [
      CalendarEventItem(
        id: 'e1',
        title: 'Persiapan Proposal Klien',
        time: '10:00 - 11:30',
        duration: '1.5 jam',
        location: 'Online Meeting',
        color: AppColors.info,
        category: 'Workspace',
      ),
    ],
    4: [
      CalendarEventItem(
        id: 'e2',
        title: 'Rapat Proyek Kampus',
        time: '09:00 - 10:00',
        duration: '1 jam',
        location: 'Zoom Meeting',
        color: AppColors.primaryOrange,
        category: 'Rapat',
        isCompleted: true,
      ),
      CalendarEventItem(
        id: 'e3',
        title: 'Landing page for TRIPPIES',
        time: '11:00 - 13:00',
        duration: '2 jam',
        location: 'Design Studio',
        color: AppColors.success,
        category: 'Tugas',
      ),
      CalendarEventItem(
        id: 'e4',
        title: 'Review Tugas Harian',
        time: '14:00 - 15:30',
        duration: '1.5 jam',
        location: 'Google Meet',
        color: AppColors.purple,
        category: 'Project',
      ),
      CalendarEventItem(
        id: 'e5',
        title: 'Evaluasi Rekrutmen Tim',
        time: '16:00 - 17:00',
        duration: '1 jam',
        location: 'Ruang Meeting 2',
        color: AppColors.warning,
        category: 'Internal',
      ),
    ],
    8: [
      CalendarEventItem(
        id: 'e6',
        title: 'Sprint Planning Mingguan',
        time: '09:30 - 11:00',
        duration: '1.5 jam',
        location: 'Zoom',
        color: AppColors.primaryOrange,
        category: 'Rapat',
      ),
    ],
    12: [
      CalendarEventItem(
        id: 'e7',
        title: 'Deadline UI Testing Prototype',
        time: '17:00',
        duration: 'Milestone',
        location: 'GitHub / Jira',
        color: AppColors.success,
        category: 'Deadline',
      ),
      CalendarEventItem(
        id: 'e8',
        title: 'Sesi Deep Work & Coding API',
        time: '19:00 - 21:00',
        duration: '2 jam',
        location: 'Home Workspace',
        color: AppColors.info,
        category: 'Fokus',
      ),
    ],
    15: [
      CalendarEventItem(
        id: 'e9',
        title: 'Presentasi Klien Tahap 2',
        time: '13:30 - 15:00',
        duration: '1.5 jam',
        location: 'Ruang Rapat Utama',
        color: AppColors.primaryOrange,
        category: 'Rapat',
      ),
      CalendarEventItem(
        id: 'e10',
        title: 'Review Catatan REST API',
        time: '16:00 - 17:00',
        duration: '1 jam',
        location: 'Notion / Supabase',
        color: AppColors.purple,
        category: 'Belajar',
      ),
    ],
    22: [
      CalendarEventItem(
        id: 'e11',
        title: 'Due Date: Task Planner Apps',
        time: '23:59',
        duration: 'Deadline',
        location: 'App Store / Play Store',
        color: AppColors.warning,
        category: 'Deadline',
      ),
    ],
    28: [
      CalendarEventItem(
        id: 'e12',
        title: 'Monthly Team Retrospective',
        time: '15:00 - 16:30',
        duration: '1.5 jam',
        location: 'Google Meet',
        color: AppColors.primaryOrange,
        category: 'Rapat',
      ),
    ],
  };

  final List<Map<String, dynamic>> _weekDays = [
    {'num': '3', 'day': 'Tue'},
    {'num': '4', 'day': 'Wed'},
    {'num': '5', 'day': 'Thu'},
    {'num': '6', 'day': 'Fri'},
    {'num': '7', 'day': 'Sat'},
    {'num': '8', 'day': 'Sun'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildViewModeToggle(),
              const SizedBox(height: 18),
              if (_viewMode == CalendarViewMode.month) ...[
                _buildMonthCalendarGrid(),
                const SizedBox(height: 20),
                _buildSelectedDayDetailSection(),
              ] else ...[
                _buildTimelineDateSection(),
                const SizedBox(height: 16),
                _buildTimelineBannerShortcut(),
                const SizedBox(height: 20),
                _buildWorkspaceCards(),
                const SizedBox(height: 24),
                _buildTodayTaskSection(),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildActionFabs(),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.orangeGradient,
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good Morning ☁️',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Peter Drogba',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── View Mode Switcher (Bulanan / Mingguan) ─────────────────────────────
  Widget _buildViewModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildToggleOption(
            title: 'Bulanan (30 Hari)',
            mode: CalendarViewMode.month,
            icon: Icons.calendar_view_month_rounded,
          ),
          _buildToggleOption(
            title: 'Mingguan (Workspaces)',
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
    final isSelected = _viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: AppColors.primaryOrangeGlow,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Full 30-Day Month Calendar Grid ───────────────────────────────────────
  Widget _buildMonthCalendarGrid() {
    final monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final monthTitle = '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';
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
                      '${_monthEvents.values.fold(0, (sum, list) => sum + list.length)} Kegiatan',
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
              final isSelected = dayNumber == _selectedDay;
              final eventsForDay = _monthEvents[dayNumber] ?? [];
              final hasEvents = eventsForDay.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDay = dayNumber);
                },
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

  // ─── Selected Day Detail Section (Agenda Harian Tanggal Terpilih) ─────────
  Widget _buildSelectedDayDetailSection() {
    final events = _monthEvents[_selectedDay] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agenda $_selectedDay Juni 2026',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  events.isEmpty
                      ? 'Tidak ada agenda jadwal pada tanggal ini'
                      : '${events.length} kegiatan terjadwal',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewTaskFormScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 14,
                      color: AppColors.primaryOrangeLight,
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryOrangeLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            alignment: Alignment.center,
            child: Column(
              children: const [
                Icon(
                  Icons.event_available_rounded,
                  color: AppColors.textMuted,
                  size: 32,
                ),
                SizedBox(height: 6),
                Text(
                  'Hari ini bebas kegiatan!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Gunakan form manual atau minta Alexa menjadwalkan agenda.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...events.map((event) => _buildDayEventCard(event)),
      ],
    );
  }

  Widget _buildDayEventCard(CalendarEventItem event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: event.color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.time,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: event.color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: event.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.category,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: event.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (event.isCompleted)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
        ],
      ),
    );
  }

  // ─── Mode 2: Week Strip & Workspaces Overview (From User Reference) ───────
  Widget _buildTimelineDateSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ManageTimelineScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrangeSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.view_timeline_rounded,
                          size: 13,
                          color: AppColors.primaryOrangeLight,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Timeline Jam ↗',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primaryOrangeLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'June ▾',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _weekDays.map((item) {
            final isSelected = item['num'] == '$_selectedDay';
            return GestureDetector(
              onTap: () {
                setState(() => _selectedDay = int.parse(item['num'] as String));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 68,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryOrange : AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.cardBorder,
                  ),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: AppColors.primaryOrangeGlow,
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['num'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['day'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white.withOpacity(0.9)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWorkspaceCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Proyek Kuliah',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                _buildWorkspaceCheckItem('Rapat Proyek Kampus', true),
                const SizedBox(height: 6),
                _buildWorkspaceCheckItem('Daily Report', false),
                const SizedBox(height: 16),
                const Text(
                  'Mick Task Project',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                _buildWorkspaceCheckItem('Create Invoice', false),
                const SizedBox(height: 6),
                _buildWorkspaceCheckItem('Send brief to Developers', false),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Task', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          Text('8/10 done', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                        ],
                      ),
                      Text('90%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primaryOrange)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: AppColors.primaryOrangeGlow, blurRadius: 20, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shared Workspace', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                _buildWhiteCheckItem('Tugas Harian'),
                const SizedBox(height: 6),
                _buildWhiteCheckItem('Proyek Kuliah'),
                const SizedBox(height: 16),
                const Text('Private Workspace', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                _buildWhiteCheckItem('Shoot on Dribbble'),
                const SizedBox(height: 6),
                _buildWhiteCheckItem('Daily Report Columbus'),
                const SizedBox(height: 6),
                _buildWhiteCheckItem('Read the Quran'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkspaceCheckItem(String label, bool isChecked) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isChecked ? AppColors.primaryOrange : Colors.transparent,
            border: Border.all(color: isChecked ? AppColors.primaryOrange : AppColors.textMuted, width: 1.5),
          ),
          child: isChecked ? const Icon(Icons.check, size: 9, color: Colors.white) : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isChecked ? AppColors.textPrimary : AppColors.textSecondary,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteCheckItem(String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayTaskSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Today's Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text('See more', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Rapat Proyek Kampus',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF16161A)),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Prepare meeting with them at 09:00 PM',
                    style: TextStyle(fontSize: 11, color: Color(0xFF71717A)),
                  ),
                ],
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF16161A)),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Shortcut Sub-Halaman: Timeline Jam (Layar Penuh) ─────────────────────
  Widget _buildTimelineBannerShortcut() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ManageTimelineScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryOrange.withOpacity(0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrangeSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.view_timeline_rounded,
                    color: AppColors.primaryOrangeLight,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Timeline Jam (10.00 - 16.00)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Buka tampilan kisi jam & balok jadwal layar penuh',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Floating Action Buttons ───────────────────────────────────────────────
  Widget _buildActionFabs() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NewTaskFormScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryOrangeGlow,
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_rounded, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Text(
              'New Task / Jadwal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
