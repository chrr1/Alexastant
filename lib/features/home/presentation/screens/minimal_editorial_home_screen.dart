import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_controller.dart';

/// Minimalist Editorial Home Screen:
/// - Recreated to match the reference design aesthetic (pastel atmospheric gradient,
///   weather badge, dual-capsule island clock, editorial greeting, and floating flight/activity hero card).
/// - Completely isolated in this new file, preserving the original home screen intact.
class MinimalEditorialHomeScreen extends StatefulWidget {
  const MinimalEditorialHomeScreen({super.key});

  @override
  State<MinimalEditorialHomeScreen> createState() =>
      _MinimalEditorialHomeScreenState();
}

class _MinimalEditorialHomeScreenState extends State<MinimalEditorialHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _themeController;
  late final Animation<double> _themeAnim;

  @override
  void initState() {
    super.initState();
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

  void _toggleTheme() {
    ThemeController.instance.toggleTheme();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    return '$dayName, $monthName ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeAnim,
      builder: (context, _) {
        final t = _themeAnim.value;
        final isDark = t < 0.5;

        // Colors
        final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final textSecondary = isDark
            ? const Color(0xFF94A3B8)
            : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-0.8, -0.9),
                end: const Alignment(0.9, 0.95),
                colors: [
                  Color.lerp(const Color(0xFF0C101C), const Color(0xFFD6E4F4), t)!,
                  Color.lerp(const Color(0xFF111728), const Color(0xFFFDE8DC), t)!,
                  Color.lerp(const Color(0xFF18152C), const Color(0xFFECE3F8), t)!,
                  Color.lerp(const Color(0xFF0C111E), const Color(0xFFDCE7F7), t)!,
                ],
                stops: const [0.0, 0.38, 0.72, 1.0],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Hitung jarak dinamis agar "Good morning, Amelia" berada hampir di tengah layar
                  // persis seperti tata letak pada gambar referensi.
                  final availableHeight = constraints.maxHeight;
                  // Estimasi tinggi elemen: top bar (~60) + greeting (~95) + hero card (~210) + navbar (~95)
                  final topSpacing = (availableHeight * 0.16).clamp(70.0, 160.0);

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // ─── 1. Top Bar (Weather Pill, Dual-Island Capsule, Avatar) ─────
                          _buildTopBar(isDark: isDark),

                          // Jarak luas bernapas yang memposisikan greeting ke tengah
                          SizedBox(height: topSpacing),
                          const SizedBox(height: 40),

                          // ─── 2. Editorial Date & Greeting (Luxury Editorial Style) ──────
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.white.withOpacity(0.60),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(0.12)
                                    : Colors.white.withOpacity(0.85),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E293B).withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6366F1), // Indigo jewel dot
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  _getFormattedDate(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getGreeting(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 34,
                              fontWeight: FontWeight.w400, // Clean, relaxed modern sans
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              letterSpacing: -0.6,
                              height: 1.15,
                            ),
                          ),
                          Text(
                            'Amelia',
                            style: GoogleFonts.newsreader(
                              fontSize: 38,
                              fontWeight: FontWeight.w700, // Rich contemporary serif
                              fontStyle: FontStyle.italic,
                              color: textPrimary,
                              letterSpacing: -0.5,
                              height: 1.15,
                            ),
                          ),

                          const SizedBox(height: 134),

                          // ─── 3. Floating Frosted Glass Hero Card (Jadwal Kuliah Terdekat) ─────
                          _buildHeroScheduleCard(
                            isDark: isDark,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),

                          // Ruang lega di bawah agar sejajar tepat di atas floating navbar
                          const SizedBox(height: 110),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── TOP BAR WIDGETS ────────────────────────────────────────────────────────
  Widget _buildTopBar({required bool isDark}) {
    final pillBg = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.60);
    final pillBorder = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.white.withOpacity(0.85);
    final pillShadow = isDark
        ? Colors.black.withOpacity(0.3)
        : const Color(0xFF1E293B).withOpacity(0.06);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Weather Pill (Left)
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: pillBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: pillShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFBBF24), // Warm sun yellow
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFBBF24),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '28°',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),

        // 2. Center Dual-Island Capsule (Analog Clock + Cosmic Theme Orb)
        GestureDetector(
          onTap: _toggleTheme,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: pillBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: pillShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left Half: Mini Analog Clock
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: _MiniClockPainter(
                      handColor: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Right Half: Dark Celestial Orb (Theme Toggle)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.3),
                      radius: 0.9,
                      colors: [
                        Color(0xFF3B2D54),
                        Color(0xFF131124),
                        Color(0xFF080612),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.20),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.35),
                        blurRadius: 10,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. User Avatar Pill (Right)
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE11D48), // Rose Crimson
                Color(0xFFBE123C),
                Color(0xFF881337),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE11D48).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  // ─── HERO SCHEDULE CARD (OPTION 1: SESI KULIAH / AGENDA TERDEKAT) ──────────
  Widget _buildHeroScheduleCard({
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final cardBg = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.68);
    final cardBorder = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.white.withOpacity(0.90);

    final innerBg = isDark
        ? const Color(0xFF0F172A).withOpacity(0.55)
        : Colors.white.withOpacity(0.60);
    final innerBorder = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.80);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : const Color(0xFF334A66).withOpacity(0.09),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Top Section: Course / Agenda Info & Badges ───────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Berikutnya',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF475569),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Rekayasa Perangkat Lunak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Location & Room Tag Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.12)
                                : Colors.white.withOpacity(0.9),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Lab Komputer 3 • Gedung F',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569),
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Badges (Academic Category Icon + Overlapping SKS Badge Pill)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Academic / Category Circle Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
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
                          Icons.terminal_rounded,
                          size: 18,
                          color: Color(0xFF1E3A8A), // Tech/Software Navy Blue
                        ),
                      ),
                    ),

                    // Blue SKS Badge overlapping with soft blue glow
                    Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB), // Vibrant royal blue
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.45),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '3 SKS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Bottom Section: Session Time Trajectory Schedule ─────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                color: innerBg,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: innerBorder, width: 1.2),
              ),
              child: Row(
                children: [
                  // Start Time: 09:30
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '09:30',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'MULAI',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  // Center: Trajectory Arc Painter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SizedBox(
                        height: 34,
                        child: CustomPaint(
                          painter: _FlightTrajectoryPainter(
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // End Time: 11:45
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '11:45',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'SELESAI',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── MINI ANALOG CLOCK PAINTER ───────────────────────────────────────────────
class _MiniClockPainter extends CustomPainter {
  final Color handColor;

  _MiniClockPainter({required this.handColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round;

    // Hour hand (pointing towards 10 o'clock)
    paint.strokeWidth = 2.0;
    const hourAngle = -math.pi * 0.45;
    final hourEnd = Offset(
      center.dx + math.cos(hourAngle) * (size.width * 0.22),
      center.dy + math.sin(hourAngle) * (size.width * 0.22),
    );
    canvas.drawLine(center, hourEnd, paint);

    // Minute hand (pointing towards 3 o'clock / horizontal)
    paint.strokeWidth = 1.6;
    const minAngle = 0.0;
    final minEnd = Offset(
      center.dx + math.cos(minAngle) * (size.width * 0.32),
      center.dy + math.sin(minAngle) * (size.width * 0.32),
    );
    canvas.drawLine(center, minEnd, paint);

    // Center pivot dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 2.2, paint);
  }

  @override
  bool shouldRepaint(covariant _MiniClockPainter oldDelegate) =>
      oldDelegate.handColor != handColor;
}

// ─── FLIGHT TRAJECTORY CURVED DOTTED ARC PAINTER ────────────────────────────
class _FlightTrajectoryPainter extends CustomPainter {
  final Color color;

  _FlightTrajectoryPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(4, size.height * 0.70);
    final end = Offset(size.width - 4, size.height * 0.70);
    final control = Offset(size.width / 2, size.height * 0.08);

    // Terminal dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(start, 3.2, dotPaint);
    canvas.drawCircle(end, 3.2, dotPaint);

    // Draw dashed quadratic curve
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;

    const dashWidth = 3.5;
    const dashSpace = 4.0;
    double distance = 6.0;

    final dashPaint = Paint()
      ..color = color.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    while (distance < totalLength - 6.0) {
      final extractLength = math.min(dashWidth, totalLength - 6.0 - distance);
      final segment = pathMetrics.extractPath(distance, distance + extractLength);
      canvas.drawPath(segment, dashPaint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _FlightTrajectoryPainter oldDelegate) =>
      oldDelegate.color != color;
}



