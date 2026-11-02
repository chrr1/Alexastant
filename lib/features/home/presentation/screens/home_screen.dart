import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/device_card.dart';
import '../widgets/recent_prompt_tile.dart';
import '../../../voice/presentation/screens/voice_conversation_screen.dart';
import '../../../chat/presentation/screens/reminder_request_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Custom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(
                    icon: Icons.grid_view_rounded,
                    onTap: () {},
                  ),
                  const Text(
                    'Alexa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Stack(
                    children: [
                      _buildIconButton(
                        icon: Icons.mail_outline_rounded,
                        onTap: () {},
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // User greeting & main hero title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'hello Peter 👋',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'What can i\nhelp you with?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Filter chips row
                    const FilterChipsBar(),

                    const SizedBox(height: 20),

                    // Two Grid Action Cards
                    Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const VoiceConversationScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: DeviceCard(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Recent Prompt Items
                    RecentPromptTile(
                      icon: Icons.mail_outline_rounded,
                      title: 'Send an email to friend',
                      subtitle:
                          'Send an email to friend Leana with my email account...',
                      onTap: () {},
                    ),
                    RecentPromptTile(
                      icon: Icons.videocam_outlined,
                      title: 'Make reminder to meet',
                      subtitle: 'Remind me to hold an online meeting with...',
                      isHighlighted: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ReminderRequestScreen(),
                          ),
                        );
                      },
                    ),
                    RecentPromptTile(
                      icon: Icons.fastfood_outlined,
                      title: 'Order Food',
                      subtitle:
                          'Order burger deluxe from nearest restaurant that...',
                      onTap: () {},
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
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
          size: 20,
        ),
      ),
    );
  }
}

