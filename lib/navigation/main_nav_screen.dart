import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../features/home/presentation/screens/minimal_editorial_home_screen.dart';
import '../features/tasks/presentation/screens/tasks_screen.dart';
import '../features/calendar/presentation/screens/calendar_screen.dart';
import '../features/notes/presentation/screens/notes_screen.dart';
import '../features/voice/presentation/screens/alexa_chat_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen>
    with TickerProviderStateMixin {
  // 0: Home, 1: Tasks, 2: Calendar, 3: Notes, 4: Voice AI (Chat)
  int _currentIndex = 0;

  // ── Theme animation ────────────────────────────────────────────────────────
  AnimationController? _themeController;
  Animation<double>? _themeAnim;

  // ── Alexa Breathing Pulse animation ─────────────────────────────────────────
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  void _ensureThemeInitialized() {
    if (_themeController != null) return;
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

  void _onThemeChanged() {
    _ensureThemeInitialized();
    if (ThemeController.instance.isDarkMode) {
      _themeController?.reverse();
    } else {
      _themeController?.forward();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ensureThemeInitialized();
    ThemeController.instance.addListener(_onThemeChanged);

    // Continuous breathing pulse for Alexa Voice button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnim = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    _themeController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // 0: Home, 1: Tasks, 2: Calendar, 3: Notes, 4: Voice AI
  final List<Widget> _screens = const [
    MinimalEditorialHomeScreen(),
    TasksScreen(),
    CalendarScreen(),
    NotesScreen(),
    AlexaChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    _ensureThemeInitialized();

    return AnimatedBuilder(
      animation: Listenable.merge([_themeAnim!, _pulseAnim]),
      builder: (context, _) {
        final t = _themeAnim!.value;
        final pulse = _pulseAnim.value;

        // Background screen
        final bg = Color.lerp(
          const Color(0xFF0B0B0E),
          const Color(0xFFF4F6F9),
          t,
        )!;

        // Island Pill Capsule styling
        final pillBg = Color.lerp(
          const Color(0xFF1E1F25),
          Colors.white,
          t,
        )!;
        final pillBorder = Color.lerp(
          Colors.white.withOpacity(0.08),
          Colors.black.withOpacity(0.06),
          t,
        )!;
        final pillShadow = Color.lerp(
          Colors.black.withOpacity(0.45),
          Colors.black.withOpacity(0.08),
          t,
        )!;

        // Pill Item indicator & icon colors
        final activeItemBg = Color.lerp(
          Colors.white.withOpacity(0.12),
          const Color(0xFFF0F2F5),
          t,
        )!;
        final activeIconColor = Color.lerp(
          Colors.white,
          const Color(0xFF16161A),
          t,
        )!;
        final inactiveIconColor = Color.lerp(
          const Color(0xFF71717A),
          const Color(0xFFA1A1AA),
          t,
        )!;

        // Voice FAB button styling
        final voiceBtnBg = Color.lerp(
          const Color(0xFF1E1F25),
          const Color(0xFF18181B),
          t,
        )!;
        final voiceBtnBorder = Color.lerp(
          Colors.white.withOpacity(0.12),
          Colors.black.withOpacity(0.1),
          t,
        )!;
        final accentOrange = const Color(0xFFFF5714);

        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildFloatingBottomBar(
                  pillBg: pillBg,
                  pillBorder: pillBorder,
                  pillShadow: pillShadow,
                  activeItemBg: activeItemBg,
                  activeIconColor: activeIconColor,
                  inactiveIconColor: inactiveIconColor,
                  voiceBtnBg: voiceBtnBg,
                  voiceBtnBorder: voiceBtnBorder,
                  accentOrange: accentOrange,
                  pulse: pulse,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingBottomBar({
    required Color pillBg,
    required Color pillBorder,
    required Color pillShadow,
    required Color activeItemBg,
    required Color activeIconColor,
    required Color inactiveIconColor,
    required Color voiceBtnBg,
    required Color voiceBtnBorder,
    required Color accentOrange,
    required double pulse,
  }) {
    final isVoiceActive = _currentIndex == 4;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // 1. Kapsul Navigasi Utama (Home, Tasks, Calendar, Notes)
              Expanded(
                child: Container(
                  height: 62,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: pillBg,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: pillBorder, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: pillShadow,
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPillNavItem(
                        index: 0,
                        activeIcon: Icons.home_rounded,
                        inactiveIcon: Icons.home_outlined,
                        activeItemBg: activeItemBg,
                        activeIconColor: activeIconColor,
                        inactiveIconColor: inactiveIconColor,
                      ),
                      _buildPillNavItem(
                        index: 1,
                        activeIcon: Icons.pie_chart_rounded,
                        inactiveIcon: Icons.pie_chart_outline_rounded,
                        activeItemBg: activeItemBg,
                        activeIconColor: activeIconColor,
                        inactiveIconColor: inactiveIconColor,
                      ),
                      _buildPillNavItem(
                        index: 2,
                        activeIcon: Icons.calendar_month_rounded,
                        inactiveIcon: Icons.calendar_month_outlined,
                        activeItemBg: activeItemBg,
                        activeIconColor: activeIconColor,
                        inactiveIconColor: inactiveIconColor,
                      ),
                      _buildPillNavItem(
                        index: 3,
                        activeIcon: Icons.sticky_note_2_rounded,
                        inactiveIcon: Icons.sticky_note_2_outlined,
                        activeItemBg: activeItemBg,
                        activeIconColor: activeIconColor,
                        inactiveIconColor: inactiveIconColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // 2. Tombol Bulat Terpisah untuk Alexa Voice AI
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 4),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 62,
                  height: 62,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Ambient Breathing Glow Effect
                      Container(
                        width: isVoiceActive
                            ? (58 + (pulse * 8))
                            : (52 + (pulse * 4)),
                        height: isVoiceActive
                            ? (58 + (pulse * 8))
                            : (52 + (pulse * 4)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isVoiceActive
                              ? accentOrange.withOpacity(0.25 + (pulse * 0.15))
                              : accentOrange.withOpacity(0.04 + (pulse * 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: isVoiceActive
                                  ? accentOrange.withOpacity(0.4 + (pulse * 0.2))
                                  : accentOrange.withOpacity(0.08),
                              blurRadius: isVoiceActive ? 18 : 8,
                              spreadRadius: isVoiceActive ? 2 : 0,
                            ),
                          ],
                        ),
                      ),

                      // Main Circle Voice Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isVoiceActive
                              ? AppColors.orangeGradient
                              : null,
                          color: isVoiceActive ? null : voiceBtnBg,
                          border: Border.all(
                            color: isVoiceActive
                                ? Colors.white.withOpacity(0.3)
                                : voiceBtnBorder,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isVoiceActive
                                  ? AppColors.primaryOrangeGlow
                                  : Colors.black.withOpacity(0.25),
                              blurRadius: isVoiceActive ? 16 : 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            isVoiceActive
                                ? Icons.mic_rounded
                                : Icons.mic_none_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Color activeItemBg,
    required Color activeIconColor,
    required Color inactiveIconColor,
  }) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? activeItemBg : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isActive ? 1.08 : 0.95,
            child: Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? activeIconColor : inactiveIconColor,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
