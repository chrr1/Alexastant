import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../domain/models/today_task_item.dart';
import '../widgets/clean_metric_row.dart';
import '../widgets/cognitive_load_card.dart';
import '../widgets/editorial_header.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/next_up_card.dart';
import '../widgets/rhythm_soundwave_card.dart';
import '../widgets/signature_bento_cards.dart';
import '../widgets/today_priority_tasks_card.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with SingleTickerProviderStateMixin {
  // Theme state: bound to global ThemeController
  bool get _isDarkMode => ThemeController.instance.isDarkMode;
  AnimationController? _themeController;
  Animation<double>? _themeAnim;

  void _ensureThemeInitialized() {
    if (_themeController == null) {
      _themeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 380),
        value: ThemeController.instance.isDarkMode ? 0.0 : 1.0,
      );
      _themeAnim = CurvedAnimation(
        parent: _themeController!,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // Priority tasks for today with interactive toggle
  final List<TodayTaskItem> _todayTasks = [
    TodayTaskItem(
      id: 't1',
      title: 'Laporan Praktikum Pemrograman Mobile',
      matkul: 'Pemrograman Mobile',
      due: '17:00',
      isCompleted: false,
    ),
    TodayTaskItem(
      id: 't2',
      title: 'Review Materi Normalisasi Basis Data',
      matkul: 'Basis Data',
      due: '21:00',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ensureThemeInitialized();
    ThemeController.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    _themeController?.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    _ensureThemeInitialized();
    if (ThemeController.instance.isDarkMode) {
      _themeController?.reverse();
    } else {
      _themeController?.forward();
    }
    setState(() {});
  }

  void _toggleTheme() {
    _ensureThemeInitialized();
    ThemeController.instance.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    _ensureThemeInitialized();
    final anim = _themeAnim!;

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        final t = anim.value;

        // ─── Continuous Interpolated Palette Tokens ─────────────────────────
        final accentColor = Color.lerp(
          const Color(0xFFFF5714),
          const Color(0xFF0A84FF),
          t,
        )!;
        final bg = Color.lerp(
          const Color(0xFF0B0B0E),
          const Color(0xFFF0F4F8),
          t,
        )!;
        final cardBg = Color.lerp(
          const Color(0xFF14141A),
          Colors.white,
          t,
        )!;
        final cardInnerBg = Color.lerp(
          const Color(0xFF1A1A22),
          const Color(0xFFF1F5F9),
          t,
        )!;
        final cardBorder = Color.lerp(
          Colors.white.withOpacity(0.06),
          const Color(0xFFDCE4EE),
          t,
        )!;
        final textPrimary = Color.lerp(
          AppColors.textPrimary,
          const Color(0xFF0F172A),
          t,
        )!;
        final textMuted = Color.lerp(
          const Color(0xFF71717A),
          const Color(0xFF64748B),
          t,
        )!;
        final topBtnBg = Color.lerp(
          const Color(0xFF18181E),
          const Color(0xFFE2EBF5),
          t,
        )!;
        final topBtnBorder = Color.lerp(
          Colors.white.withOpacity(0.08),
          const Color(0xFFCBD8E6),
          t,
        )!;
        final topIconColor = Color.lerp(
          const Color(0xFFD4D4D8),
          const Color(0xFF1E293B),
          t,
        )!;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // ─── 1. Top Bar: Avatar, Theme Switch & Notification ───────
                  HomeTopBar(
                    topBtnBg: topBtnBg,
                    topBtnBorder: topBtnBorder,
                    topIconColor: topIconColor,
                    textPrimary: textPrimary,
                    accentColor: accentColor,
                    isDarkMode: _isDarkMode,
                    onToggleTheme: _toggleTheme,
                  ),

                  const SizedBox(height: 24),

                  // ─── 2. Editorial Typography Header ────────────────────────
                  EditorialHeader(
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                  ),

                  const SizedBox(height: 28),

                  // ─── 3. Signature Pill Soundwave / Rhythm Wave ─────────────
                  RhythmSoundwaveCard(
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 28),

                  // ─── 4. Clean Raw Metric Row (Beban Waktu & Waktu Luang) ───
                  CleanMetricRow(
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                  ),

                  const SizedBox(height: 24),

                  // ─── 5. Two Signature Bento Cards ──────────────────────────
                  SignatureBentoCards(
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 18),

                  // ─── 6. Beban Mental Hari Ini (Cognitive Load & Energy Meter)
                  CognitiveLoadCard(
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    cardInnerBg: cardInnerBg,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 18),

                  // ─── 7. Next Up Context Card (Kuliah Terdekat) ─────────────
                  NextUpCard(
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    topBtnBg: topBtnBg,
                    topIconColor: topIconColor,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 20),

                  // ─── 8. Prioritas Tugas Hari Ini (Micro-Checklist) ─────────
                  TodayPriorityTasksCard(
                    tasks: _todayTasks,
                    onToggleTask: (task) {
                      setState(() {
                        task.isCompleted = !task.isCompleted;
                      });
                    },
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    cardInnerBg: cardInnerBg,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 120), // Bottom padding for floating nav bar
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
