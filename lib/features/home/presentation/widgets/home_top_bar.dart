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

  @override
  Widget build(BuildContext context) {
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
              onTap: onToggleTheme,
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
                      isDarkMode
                          ? Icons.wb_sunny_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey<bool>(isDarkMode),
                      color: isDarkMode
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
}

