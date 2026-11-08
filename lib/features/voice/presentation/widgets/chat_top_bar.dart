import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/voice/presentation/screens/voice_conversation_screen.dart';

/// Header bar untuk halaman Chat AI.
/// Menampilkan identitas Alexa (ikon + nama + status online)
/// dan tombol shortcut ke Voice Mode di sisi kanan.
class ChatTopBar extends StatelessWidget {
  const ChatTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Identitas Alexa
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.orangeGradient,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alexa AI Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.success),
                      SizedBox(width: 5),
                      Text(
                        'Online · Siap Membantu',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Shortcut ke Voice Mode
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const VoiceConversationScreen(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryOrangeSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.mic_rounded,
                    color: AppColors.primaryOrangeLight,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Voice Mode',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrangeLight,
                    ),
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

