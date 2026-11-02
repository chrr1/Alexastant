import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/action_confirmation_card.dart';
import '../widgets/chat_input_bar.dart';
import '../../../voice/presentation/screens/voice_conversation_screen.dart';

class ReminderRequestScreen extends StatefulWidget {
  const ReminderRequestScreen({super.key});

  @override
  State<ReminderRequestScreen> createState() => _ReminderRequestScreenState();
}

class _ReminderRequestScreenState extends State<ReminderRequestScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

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
                    'Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  _buildIconButton(
                    icon: Icons.info_outline_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Scrollable Chat History
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // User Request Message Bubble
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.82,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(4),
                              ),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: const Text(
                              'Remind me to hold an online meeting with my work team using Zoom at 1 pm to discuss annual employee recruitment, and use the zoom.com link',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFE5E7EB),
                                height: 1.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              '11:45',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // AI Generated Action Confirmation Card
                    ActionConfirmationCard(
                      title: 'Meeting with Team',
                      dateSubtitle: 'Monday, 09 September 2024',
                      description:
                          "I hope this email finds you well! It's been a while since we last caught up, and I wanted to check in and see how you're doing..",
                      onCancel: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jadwal rapat dibatalkan.'),
                            backgroundColor: AppColors.surfaceSecondary,
                          ),
                        );
                      },
                      onConfirm: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Jadwal dan pengingat rapat berhasil dibuat!',
                            ),
                            backgroundColor: AppColors.primaryOrange,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Input Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: ChatInputBar(
                controller: _inputController,
                onSend: () {
                  if (_inputController.text.isNotEmpty) {
                    _inputController.clear();
                  }
                },
                onMicTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VoiceConversationScreen(),
                    ),
                  );
                },
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
}

