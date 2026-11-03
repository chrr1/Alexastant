import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../voice/presentation/screens/voice_conversation_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with SingleTickerProviderStateMixin {
  // Theme state: defaults to dark mode (0.0), transitions to light mode (1.0)
  bool _isDarkMode = true;
  AnimationController? _themeController;
  Animation<double>? _themeAnim;

  void _ensureThemeInitialized() {
    if (_themeController == null) {
      _themeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 380),
        value: _isDarkMode ? 0.0 : 1.0,
      );
      _themeAnim = CurvedAnimation(
        parent: _themeController!,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // Mock priority tasks for today with interactive toggle
  final List<Map<String, dynamic>> _todayTasks = [
    {
      'id': 't1',
      'title': 'Laporan Praktikum Pemrograman Mobile',
      'matkul': 'Pemrograman Mobile',
      'due': '17:00',
      'isCompleted': false,
    },
    {
      'id': 't2',
      'title': 'Review Materi Normalisasi Basis Data',
      'matkul': 'Basis Data',
      'due': '21:00',
      'isCompleted': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _ensureThemeInitialized();
  }

  @override
  void dispose() {
    _themeController?.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    _ensureThemeInitialized();
    setState(() {
      _isDarkMode = !_isDarkMode;
      if (_isDarkMode) {
        _themeController?.reverse();
      } else {
        _themeController?.forward();
      }
    });
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
                  _buildTopBar(
                    context,
                    topBtnBg: topBtnBg,
                    topBtnBorder: topBtnBorder,
                    topIconColor: topIconColor,
                    textPrimary: textPrimary,
                    accentColor: accentColor,
                  ),

                  const SizedBox(height: 24),

                  // ─── 2. Editorial Typography Header ────────────────────────
                  _buildEditorialHeader(
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                  ),

                  const SizedBox(height: 28),

                  // ─── 3. Signature Pill Soundwave / Rhythm Wave ─────────────
                  _buildRhythmSoundwave(
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 28),

                  // ─── 4. Clean Raw Metric Row (Beban Waktu & Waktu Luang) ───
                  _buildCleanMetricRow(
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                  ),

                  const SizedBox(height: 24),

                  // ─── 5. Two Signature Bento Cards ──────────────────────────
                  _buildSignatureBentoCards(
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 18),

                  // ─── 6. Beban Mental Hari Ini (Cognitive Load & Energy Meter)
                  _buildCognitiveLoadCard(
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
                  _buildNextUpCard(
                    context,
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
                  _buildTodayPriorityTasks(
                    cardBg: cardBg,
                    cardBorder: cardBorder,
                    cardInnerBg: cardInnerBg,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    accentColor: accentColor,
                    animProgress: t,
                  ),

                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── 1. Top Bar ────────────────────────────────────────────────────────────
  Widget _buildTopBar(
    BuildContext context, {
    required Color topBtnBg,
    required Color topBtnBorder,
    required Color topIconColor,
    required Color textPrimary,
    required Color accentColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar Monogram
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: topBtnBg,
            border: Border.all(color: topBtnBorder),
          ),
          child: Center(
            child: Text(
              'P',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),

        // Action Buttons: Theme Switcher & Notification
        Row(
          children: [
            // Smooth Theme Switcher Button
            GestureDetector(
              onTap: _toggleTheme,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: topBtnBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: topBtnBorder),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: Icon(
                      _isDarkMode
                          ? Icons.wb_sunny_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey<bool>(_isDarkMode),
                      color: _isDarkMode
                          ? const Color(0xFFFFB703) // Warm amber sun
                          : const Color(0xFF0A84FF), // Cobalt blue moon
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Notification Icon with Accent Count Dot
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const VoiceConversationScreen(
                      transcriptText: 'Alexa, apa prioritasku hari ini?',
                    ),
                  ),
                );
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: topBtnBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: topBtnBorder),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: topIconColor,
                      size: 20,
                    ),
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── 2. Editorial Typography Header ────────────────────────────────────────
  Widget _buildEditorialHeader({
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hari Ini',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.6,
            height: 1.15,
          ),
        ),
        Text(
          '02 November',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.8,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ritme Optimal',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textMuted,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─── 3. Signature Pill Soundwave Visualizer ────────────────────────────────
  Widget _buildRhythmSoundwave({
    required Color accentColor,
    required double animProgress,
  }) {
    return SizedBox(
      height: 145,
      width: double.infinity,
      child: CustomPaint(
        painter: _PillSoundwavePainter(
          accentColor: accentColor,
          animProgress: animProgress,
        ),
      ),
    );
  }

  // ─── 4. Clean Raw Metric Row (Beban Waktu & Waktu Luang) ───────────────────
  Widget _buildCleanMetricRow({
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Jam Kuliah',
                style: TextStyle(
                  fontSize: 12,
                  color: textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '4.5',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'jam hari ini',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waktu Luang',
                style: TextStyle(
                  fontSize: 12,
                  color: textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '3.0',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'jam tersedia',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── 5. Two Signature Bento Cards ──────────────────────────────────────────
  Widget _buildSignatureBentoCards({
    required Color accentColor,
    required double animProgress,
  }) {
    return Row(
      children: [
        // CARD 1: Solid Accent Card (Orange in Dark, #0A84FF in Light)
        Expanded(
          child: Container(
            height: 175,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sesi Fokus',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: -0.1,
                  ),
                ),
                // Smooth Curved Line Chart (Bezier)
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SmoothCurvePainter(),
                  ),
                ),
                // Metric bottom value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '3h 45m',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'aktif',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // CARD 2: Midnight / Slate Bento Card with Histogram Bars
        Expanded(
          child: Container(
            height: 175,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color.lerp(
                const Color(0xFF1B1B22),
                const Color(0xFF111927),
                animProgress,
              )!,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Color.lerp(
                  Colors.white.withOpacity(0.06),
                  const Color(0xFF1E293B),
                  animProgress,
                )!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3 - (animProgress * 0.2)),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tugas & Kuliah',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: -0.1,
                  ),
                ),
                // Mini Histogram Bars with tight gap
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _MiniHistogramPainter(
                      accentColor: accentColor,
                      animProgress: animProgress,
                    ),
                  ),
                ),
                // Metric bottom value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '8',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '/ 11 target',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 6. Next Up Context Card ───────────────────────────────────────────────
  Widget _buildNextUpCard(
    BuildContext context, {
    required Color cardBg,
    required Color cardBorder,
    required Color topBtnBg,
    required Color topIconColor,
    required Color textPrimary,
    required Color textMuted,
    required Color accentColor,
    required double animProgress,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const VoiceConversationScreen(
              transcriptText: 'Alexa, beritahu jadwal kuliah terdekat.',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18 - (animProgress * 0.14)),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school_outlined,
                color: accentColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10:00 • 15 menit lagi',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kuliah Pemrograman Mobile',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    'Lab Komputer 302, Gedung B',
                    style: TextStyle(
                      fontSize: 11,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: topBtnBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: topIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 7. Beban Mental Hari Ini (Cognitive Load & Energy Meter) ──────────────
  Widget _buildCognitiveLoadCard({
    required Color cardBg,
    required Color cardBorder,
    required Color cardInnerBg,
    required Color textPrimary,
    required Color textMuted,
    required Color accentColor,
    required double animProgress,
  }) {
    final unfilledBarColor = Color.lerp(
      const Color(0xFF22222A),
      const Color(0xFFE2E8F0),
      animProgress,
    )!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18 - (animProgress * 0.14)),
            blurRadius: 12,
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
              Text(
                'Beban Mental Hari Ini',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: -0.1,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '65%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• Terkendali',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 5-segment energy bar
          Row(
            children: List.generate(5, (index) {
              final isFilled = index < 3;
              final isCurrent = index == 3;
              return Expanded(
                child: Container(
                  height: 10,
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? accentColor
                        : (isCurrent
                            ? accentColor.withOpacity(0.35)
                            : unfilledBarColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          // Micro-breakdown badges
          Row(
            children: [
              _buildLoadBadge(
                Icons.school_outlined,
                '2 Sesi Kuliah',
                '3.5 jam',
                cardInnerBg: cardInnerBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              const SizedBox(width: 8),
              _buildLoadBadge(
                Icons.assignment_outlined,
                '2 Tugas',
                'Sore ini',
                cardInnerBg: cardInnerBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              const SizedBox(width: 8),
              _buildLoadBadge(
                Icons.battery_charging_full_rounded,
                'Kapasitas',
                '35% luang',
                cardInnerBg: cardInnerBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadBadge(
    IconData icon,
    String title,
    String sub, {
    required Color cardInnerBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: cardInnerBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: textMuted),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            Text(
              sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 8. Prioritas Tugas Hari Ini (Micro-Checklist) ─────────────────────────
  Widget _buildTodayPriorityTasks({
    required Color cardBg,
    required Color cardBorder,
    required Color cardInnerBg,
    required Color textPrimary,
    required Color textMuted,
    required Color accentColor,
    required double animProgress,
  }) {
    final completedCount =
        _todayTasks.where((t) => t['isCompleted'] == true).length;

    final uncheckedBorder = Color.lerp(
      const Color(0xFF52525B),
      const Color(0xFF94A3B8),
      animProgress,
    )!;

    final doneItemBg = Color.lerp(
      const Color(0xFF181820).withOpacity(0.5),
      const Color(0xFFF1F5F9),
      animProgress,
    )!;

    final doneTextColor = Color.lerp(
      const Color(0xFF52525B),
      const Color(0xFF94A3B8),
      animProgress,
    )!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18 - (animProgress * 0.14)),
            blurRadius: 12,
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
              Text(
                'Prioritas Hari Ini',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cardInnerBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$completedCount / ${_todayTasks.length} selesai',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._todayTasks.map((task) {
            final isDone = task['isCompleted'] as bool;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  task['isCompleted'] = !isDone;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDone ? doneItemBg : cardInnerBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDone ? Colors.transparent : cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    // Interactive Checkbox Pill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isDone ? accentColor : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? accentColor : uncheckedBorder,
                          width: 1.8,
                        ),
                      ),
                      child: isDone
                          ? const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDone ? doneTextColor : textPrimary,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: doneTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color.lerp(
                                    AppColors.primaryOrange.withOpacity(0.8),
                                    const Color(0xFF0A84FF),
                                    animProgress,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  task['matkul'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tenggat ${task['due']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOM PAINTERS (Matching the "X METHOD" Aesthetic)
// ─────────────────────────────────────────────────────────────────────────────

/// Paints the iconic vertical capsule/pill soundwave matrix with smooth interpolation.
class _PillSoundwavePainter extends CustomPainter {
  final Color accentColor;
  final double animProgress;

  _PillSoundwavePainter({
    required this.accentColor,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activePaint = Paint()..color = accentColor;
    final mutedColor = Color.lerp(
      const Color(0xFF2E2E36),
      const Color(0xFFBACADB),
      animProgress,
    )!;
    final mutedPaint = Paint()..color = mutedColor;
    const pillGap = 5.0; // gap between stacked pills in one column
    const colGap = 5.5;  // horizontal gap between columns

    // 22 columns — bottom-anchored Gaussian bell curve.
    final columns = [
      _ColumnData(isAccent: false, pills: [14, 22]),         // col 0  ≈ 41
      _ColumnData(isAccent: false, pills: [26, 38]),         // col 1  ≈ 69
      _ColumnData(isAccent: false, pills: [58]),             // col 2    58
      _ColumnData(isAccent: false, pills: [78]),             // col 3    78
      _ColumnData(isAccent: true,  pills: [36, 52]),         // col 4  ≈ 93
      _ColumnData(isAccent: true,  pills: [22, 32, 30]),     // col 5  ≈ 94
      _ColumnData(isAccent: true,  pills: [58, 48]),         // col 6  ≈ 111
      _ColumnData(isAccent: true,  pills: [30, 76]),         // col 7  ≈ 111
      _ColumnData(isAccent: true,  pills: [42, 26, 40]),     // col 8  ≈ 118
      _ColumnData(isAccent: true,  pills: [124]),            // col 9    124 — peak
      _ColumnData(isAccent: true,  pills: [40, 56]),         // col 10 ≈ 101
      _ColumnData(isAccent: true,  pills: [128]),            // col 11   128 — APEX
      _ColumnData(isAccent: true,  pills: [42, 58]),         // col 12 ≈ 105
      _ColumnData(isAccent: true,  pills: [32, 70]),         // col 13 ≈ 107
      _ColumnData(isAccent: true,  pills: [46, 30, 40]),     // col 14 ≈ 126
      _ColumnData(isAccent: true,  pills: [118]),            // col 15   118
      _ColumnData(isAccent: true,  pills: [34, 52]),         // col 16 ≈ 91
      _ColumnData(isAccent: true,  pills: [62]),             // col 17   62
      _ColumnData(isAccent: false, pills: [38, 30]),         // col 18 ≈ 73
      _ColumnData(isAccent: false, pills: [24, 42]),         // col 19 ≈ 71
      _ColumnData(isAccent: false, pills: [52]),             // col 20   52
      _ColumnData(isAccent: false, pills: [16, 26]),         // col 21 ≈ 47
    ];

    final colWidth =
        (size.width - ((columns.length - 1) * colGap)) / columns.length;

    for (int i = 0; i < columns.length; i++) {
      final col = columns[i];
      final paint = col.isAccent ? activePaint : mutedPaint;
      final x = i * (colWidth + colGap);

      // Sum of all pill heights + gaps between them
      final totalH = col.pills.fold<double>(0, (s, h) => s + h) +
          (col.pills.length - 1) * pillGap;

      // Bottom-anchor: cluster sits 8px above the canvas floor
      double currentY = size.height - totalH - 8;

      for (final h in col.pills) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, currentY, colWidth, h.toDouble()),
            Radius.circular(colWidth / 2),
          ),
          paint,
        );
        currentY += h + pillGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PillSoundwavePainter oldDelegate) =>
      oldDelegate.accentColor != accentColor ||
      oldDelegate.animProgress != animProgress;
}

class _ColumnData {
  final bool isAccent;
  final List<int> pills;
  _ColumnData({required this.isAccent, required this.pills});
}

/// Paints the smooth bezier curve with an end dot (Card 1)
class _SmoothCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = Colors.white;

    final path = Path();
    path.moveTo(0, size.height * 0.65);

    // Smooth Bezier wave
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.90,
      size.width * 0.45,
      size.height * 0.20,
      size.width * 0.70,
      size.height * 0.75,
    );
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.95,
      size.width * 0.92,
      size.height * 0.35,
      size.width * 0.96,
      size.height * 0.25,
    );

    canvas.drawPath(path, linePaint);

    // End point dot
    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.25),
      3.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the mini histogram bars inside the dark slate card (Card 2) with smooth interpolation.
class _MiniHistogramPainter extends CustomPainter {
  final Color accentColor;
  final double animProgress;

  _MiniHistogramPainter({
    required this.accentColor,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 8 slots activity histogram with compact gap
    final barData = [
      {'ratio': 0.35, 'isHighlight': false},
      {'ratio': 0.58, 'isHighlight': false},
      {'ratio': 0.45, 'isHighlight': false},
      {'ratio': 0.75, 'isHighlight': false},
      {'ratio': 0.95, 'isHighlight': true}, // Peak / Today
      {'ratio': 0.65, 'isHighlight': false},
      {'ratio': 0.40, 'isHighlight': false},
      {'ratio': 0.55, 'isHighlight': false},
    ];

    // Compact gap between bars so they sit closely together
    const gap = 5.0;
    final barWidth =
        (size.width - ((barData.length - 1) * gap)) / barData.length;

    final normalBarColor = Color.lerp(
      Colors.white.withOpacity(0.18),
      Colors.white.withOpacity(0.28),
      animProgress,
    )!;

    for (int i = 0; i < barData.length; i++) {
      final item = barData[i];
      final ratio = item['ratio'] as double;
      final isHighlight = item['isHighlight'] as bool;

      final barH = size.height * ratio;
      final x = i * (barWidth + gap);
      final y = size.height - barH;

      final paint = Paint()
        ..color = isHighlight ? accentColor : normalBarColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barH),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniHistogramPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor ||
      oldDelegate.animProgress != animProgress;
}
