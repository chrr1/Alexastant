import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';
import 'package:alexa/features/calendar/domain/calendar_samsung_data.dart';
import 'package:alexa/features/calendar/presentation/widgets/samsung_month_grid.dart';
import 'package:alexa/features/calendar/presentation/widgets/day_agenda_bottom_sheet.dart';
import 'package:alexa/features/calendar/presentation/widgets/calendar_add_action_sheet.dart';
import 'package:alexa/features/calendar/presentation/screens/samsung_reminder_form_screen.dart';

// Re-export model & data untuk kompatibilitas
export 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';
export 'package:alexa/features/calendar/domain/calendar_samsung_data.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _themeController;
  late final Animation<double> _themeAnim;

  // Bulan default Oktober 2026 (Sesuai Gambar 3)
  final DateTime _currentMonth = DateTime(2026, 10, 1);
  int _selectedDay = 1;

  // Data event kalender
  late Map<int, List<CalendarEventItem>> _events;

  // Sinkronisasi tugas perkuliahan jatuh tempo
  final List<Map<String, dynamic>> _dueTasks = [
    {
      'id': 't1',
      'title': 'Kirim Laporan Progres Praktikum',
      'workspace': 'Kuliah',
      'matkul': 'Praktikum Audio',
      'priority': 'Tinggi',
      'isDone': false,
      'dueDay': 5,
    },
    {
      'id': 't2',
      'title': 'Belajar Persiapan UTS Mekanik',
      'workspace': 'Kuliah',
      'matkul': 'Mekanika',
      'priority': 'Sedang',
      'isDone': false,
      'dueDay': 8,
    },
    {
      'id': 't3',
      'title': 'Finalisasi Proposal HIMA',
      'workspace': 'Organisasi',
      'priority': 'Urgent',
      'isDone': true,
      'dueDay': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _events = CalendarSamsungData.getOctoberEvents();

    _themeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: ThemeController.instance.isDarkMode ? 0.0 : 1.0,
    );
    _themeAnim = CurvedAnimation(
      parent: _themeController,
      curve: Curves.easeInOutCubic,
    );
    ThemeController.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    _themeController.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    if (ThemeController.instance.isDarkMode) {
      _themeController.reverse();
    } else {
      _themeController.forward();
    }
  }

  // ─── Buka Agenda Hari Terpilih di atas Navbar (useRootNavigator: true) ─────
  void _showDayAgendaSheet() {
    final currentEvents = _events[_selectedDay] ?? [];
    final todayTasks = _dueTasks.where((t) => t['dueDay'] == _selectedDay).toList();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // PENTING: Muncul di atas bottom navigation bar
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DayAgendaBottomSheet(
        selectedDay: _selectedDay,
        monthName: 'Oktober',
        year: 2026,
        events: currentEvents,
        dueTasks: todayTasks,
        onAddEvent: _openAddOptionSheet,
        onToggleTaskDone: (task) {
          setState(() {
            task['isDone'] = !(task['isDone'] as bool);
          });
        },
      ),
    );
  }

  // ─── Modal Pilihan Tambah: Pengingat vs Jadwal Acara ─────────────
  void _openAddOptionSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Muncul di atas navbar
      backgroundColor: Colors.transparent,
      builder: (ctx) => CalendarAddActionSheet(
        selectedDay: _selectedDay,
        monthName: 'Okt',
        onOptionSelected: (option) {
          switch (option) {
            case CalendarAddOption.reminder:
              _openAddReminderScreen();
              break;
            case CalendarAddOption.scheduleEvent:
              _openAddReminderScreen(); // Form acara & waktu
              break;
          }
        },
      ),
    );
  }

  // ─── Form 1: Pengingat Baru (Samsung One UI) ──────────────────────────────
  void _openAddReminderScreen() {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, anim, secondaryAnim) => SamsungReminderFormScreen(
          initialDate: DateTime(_currentMonth.year, _currentMonth.month, _selectedDay),
          onSave: (newEvent) {
            setState(() {
              final day = newEvent.date.day;
              if (_events[day] != null) {
                _events[day]!.insert(0, newEvent);
              } else {
                _events[day] = [newEvent];
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Pengingat "${newEvent.title}" disimpan ✓'),
                backgroundColor: const Color(0xFF10B981),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        transitionsBuilder: (context, anim, secondaryAnim, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: anim, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeAnim,
      builder: (context, _) {
        final t = _themeAnim.value;
        final isDark = t < 0.5;

        final currentEvents = _events[_selectedDay] ?? [];

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF8FAFC),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ─── Top Bar: Bulan (OKT), Search, [ 13 ] ───────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 16, 6),
                  child: Row(
                    children: [
                      // Bulan Kapital Tegas (OKT)
                      Text(
                        'OKT',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),

                      // Search Icon
                      Icon(
                        Icons.search_rounded,
                        size: 24,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 14),

                      // Shortcut Icon Tanggal Hari Ini [ 13 ] Khas Samsung
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedDay = 13);
                          _showDayAgendaSheet();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                              width: 1.6,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '13',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Grid Kalender Bulanan Samsung (Full Viewport) ───────────
                Expanded(
                  child: SamsungMonthGrid(
                    currentMonth: _currentMonth,
                    selectedDay: _selectedDay,
                    events: _events,
                    isDark: isDark,
                    onDaySelected: (day) {
                      final isSameDay = _selectedDay == day;
                      setState(() => _selectedDay = day);

                      // Ketuk tanggal -> langsung perbarui dan jika diketuk lagi atau ada event, buka agenda sheet
                      if (isSameDay || (_events[day]?.isNotEmpty ?? false)) {
                        _showDayAgendaSheet();
                      }
                    },
                  ),
                ),

                // ─── Bottom Bar Samsung One UI (Tepat di Atas Navbar) ───────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 94), // 94dp: Aman di atas floating navbar
                  child: Row(
                    children: [
                      // Kapsul Input Lonjong Khas Samsung
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (currentEvents.isNotEmpty) {
                              _showDayAgendaSheet();
                            } else {
                              _openAddOptionSheet();
                            }
                          },
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF000000) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Tmbh acr pd $_selectedDay Okt',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                if (currentEvents.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6).withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${currentEvents.length} Acara',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF3B82F6),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        const Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          size: 14,
                                          color: Color(0xFF3B82F6),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Tombol Bulat Putih Besar (+) Sesuai Gambar 3
                      GestureDetector(
                        onTap: _openAddOptionSheet,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.24),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              size: 32,
                              color: Color(0xFF000000), // Plus hitam tebal khas Samsung
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
