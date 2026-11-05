import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';
import 'package:alexa/features/calendar/presentation/widgets/calendar_top_header.dart';
import 'package:alexa/features/calendar/presentation/widgets/calendar_view_mode_toggle.dart';
import 'package:alexa/features/calendar/presentation/widgets/month_calendar_grid.dart';
import 'package:alexa/features/calendar/presentation/widgets/selected_day_detail_section.dart';
import 'package:alexa/features/calendar/presentation/widgets/week_timeline_date_section.dart';
import 'package:alexa/features/calendar/presentation/widgets/timeline_banner_shortcut.dart';
import 'package:alexa/features/calendar/presentation/widgets/week_workspace_cards.dart';
import 'package:alexa/features/calendar/presentation/widgets/calendar_today_task_card.dart';
import 'package:alexa/features/calendar/presentation/widgets/calendar_add_fab.dart';

// Re-export model & enum agar kompatibel jika ada import dari luar
export 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarViewMode _viewMode = CalendarViewMode.month;
  final DateTime _currentMonth = DateTime(2026, 6, 1);
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

  // Tugas yang jatuh tempo (disinkronkan dari halaman Tasks)
  final List<Map<String, dynamic>> _dueTasks = [
    {
      'id': 't1',
      'title': 'Kirim Laporan Progres Praktikum Jarkom',
      'workspace': 'Kuliah',
      'matkul': 'Jaringan Komputer',
      'priority': 'Tinggi',
      'isDone': false,
      'dueDay': 4,
    },
    {
      'id': 't2',
      'title': 'Selesaikan Bab 3 Analisis Algoritma',
      'workspace': 'Kuliah',
      'matkul': 'Struktur Data',
      'priority': 'Sedang',
      'isDone': true,
      'dueDay': 4,
    },
    {
      'id': 't3',
      'title': 'Review PR Mockup Alexa Mobile',
      'workspace': 'Tugas Harian',
      'priority': 'Urgent',
      'isDone': false,
      'dueDay': 2,
    },
    {
      'id': 't4',
      'title': 'Push Commit Supabase Schema RLS',
      'workspace': 'Tugas Harian',
      'priority': 'Sedang',
      'isDone': false,
      'dueDay': 5,
    },
  ];

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
              const CalendarTopHeader(),
              const SizedBox(height: 16),
              CalendarViewModeToggle(
                viewMode: _viewMode,
                onChanged: (mode) => setState(() => _viewMode = mode),
              ),
              const SizedBox(height: 18),
              if (_viewMode == CalendarViewMode.month) ...[
                MonthCalendarGrid(
                  currentMonth: _currentMonth,
                  selectedDay: _selectedDay,
                  monthEvents: _monthEvents,
                  onDaySelected: (day) => setState(() => _selectedDay = day),
                ),
                const SizedBox(height: 20),
                SelectedDayDetailSection(
                  selectedDay: _selectedDay,
                  events: _monthEvents[_selectedDay] ?? [],
                  dueTasks: _dueTasks,
                  onToggleTaskDone: (task) {
                    setState(() {
                      task['isDone'] = !(task['isDone'] as bool);
                    });
                  },
                ),
              ] else ...[
                WeekTimelineDateSection(
                  selectedDay: _selectedDay,
                  weekDays: _weekDays,
                  onDaySelected: (day) => setState(() => _selectedDay = day),
                ),
                const SizedBox(height: 16),
                const TimelineBannerShortcut(),
                const SizedBox(height: 20),
                const WeekWorkspaceCards(),
                const SizedBox(height: 24),
                const CalendarTodayTaskCard(),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: const CalendarAddFab(),
    );
  }
}
