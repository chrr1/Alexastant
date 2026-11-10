import 'package:flutter/material.dart';
import '../../../voice/presentation/screens/voice_conversation_screen.dart';

class HomeTopBar extends StatelessWidget {
  final Color topBtnBg;
  final Color topBtnBorder;
  final Color topIconColor;
  final Color textPrimary;
  final Color accentColor;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeTopBar({
    super.key,
    required this.topBtnBg,
    required this.topBtnBorder,
    required this.topIconColor,
    required this.textPrimary,
    required this.accentColor,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  Widget _buildGlassCircle({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: topBtnBg,
          border: Border.all(color: topBtnBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar Monogram
        _buildGlassCircle(
          child: Text(
            'P',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),

        // Action Buttons: Theme Switcher & Notification
        Row(
          children: [
            // Smooth Theme Switcher Button
            _buildGlassCircle(
              onTap: onToggleTheme,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  isDarkMode
                      ? Icons.wb_sunny_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDarkMode),
                  color: isDarkMode
                      ? const Color(0xFFFFB703) // Warm amber sun
                      : const Color(0xFFF26875), // Radiant Coral Orchid Moon
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Notification Icon with Accent Count Dot
            _buildGlassCircle(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const VoiceConversationScreen(
                      transcriptText: 'Alexa, apa prioritasku hari ini?',
                    ),
                  ),
                );
              },
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
          ],
        ),
      ],
    );
  }
}

