import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/soundwave_visualizer.dart';
import '../widgets/glowing_mic_button.dart';
import '../../../chat/presentation/screens/reminder_request_screen.dart';

class VoiceConversationScreen extends StatelessWidget {
  final String transcriptText;

  const VoiceConversationScreen({
    super.key,
    this.transcriptText = 'Remind me to have\non online meeting\nwith my work',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Talk With Alexa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  _buildIconButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Live Transcript Typography
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.35,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(text: 'Remind me to have\non online meeting\nwith my '),
                    TextSpan(
                      text: 'work',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Animated Soundwave Visualizer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SoundwaveVisualizer(height: 110),
            ),

            const Spacer(flex: 2),

            // Bottom Action Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Switch to text mode
                  _buildControlCircle(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ReminderRequestScreen(),
                        ),
                      );
                    },
                  ),

                  // Center Glowing Mic Button
                  GlowingMicButton(
                    onTap: () {
                      // Toggle mic listening state
                    },
                  ),

                  // Cancel / Close voice mode
                  _buildControlCircle(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildControlCircle({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          icon,
          color: AppColors.textSecondary,
          size: 22,
        ),
      ),
    );
  }
}

