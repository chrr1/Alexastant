import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../features/home/presentation/screens/home_dashboard_screen.dart';
import '../features/tasks/presentation/screens/tasks_screen.dart';
import '../features/calendar/presentation/screens/calendar_screen.dart';
import '../features/notes/presentation/screens/notes_screen.dart';
import '../features/voice/presentation/screens/alexa_chat_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    TasksScreen(),
    AlexaChatScreen(),
    CalendarScreen(),
    NotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Home'),
              _buildNavItem(1, Icons.check_circle_rounded, Icons.check_circle_outline_rounded, 'Tasks'),
              // Center Alexa FAB
              _buildAlexaButton(),
              _buildNavItem(3, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Calendar'),
              _buildNavItem(4, Icons.sticky_note_2_rounded, Icons.sticky_note_2_outlined, 'Notes'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryOrangeSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.primaryOrange : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppColors.primaryOrange : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlexaButton() {
    final bool isActive = _currentIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isActive
              ? AppColors.orangeGradient
              : const LinearGradient(
                  colors: [Color(0xFF2A2A30), Color(0xFF1F1F24)],
                ),
          boxShadow: isActive
              ? [
                  const BoxShadow(
                    color: AppColors.primaryOrangeGlow,
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: const Icon(
          Icons.mic_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

