import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/voice/domain/models/chat_message_model.dart';
import 'package:alexa/features/chat/presentation/widgets/action_confirmation_card.dart';

/// Widget gelembung pesan individual dalam chat.
/// Menampilkan pesan user (kanan, abu-abu) dan pesan AI (kiri, surface).
/// Jika [ChatMessageModel.hasActionCard] true, maka menampilkan
/// [ActionConfirmationCard] di bawah gelembung pesan user.
class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final BuildContext parentContext;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return message.isUser ? _buildUserBubble(context) : _buildAiBubble();
  }

  Widget _buildUserBubble(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.82,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: Text(
            message.text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFE5E7EB),
              height: 1.45,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(
            message.time,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Kartu konfirmasi aksi (muncul setelah permintaan tertentu dari user)
        if (message.hasActionCard)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ActionConfirmationCard(
              title: 'Meeting with Team',
              dateSubtitle: 'Monday, 09 September 2024',
              description:
                  "I hope this email finds you well! It's been a while since we last caught up, and I wanted to check in and see how you're doing..",
              onCancel: () {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text('Jadwal rapat dibatalkan.'),
                    backgroundColor: AppColors.surfaceSecondary,
                  ),
                );
              },
              onConfirm: () {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Jadwal dan pengingat rapat berhasil dibuat ke kalender!',
                    ),
                    backgroundColor: AppColors.primaryOrange,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAiBubble() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              message.time,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

