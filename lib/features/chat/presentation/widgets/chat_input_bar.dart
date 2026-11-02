import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend;
  final VoidCallback? onMicTap;
  final VoidCallback? onAttachmentTap;

  const ChatInputBar({
    super.key,
    this.controller,
    this.onSend,
    this.onMicTap,
    this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                hintText: 'Send Message...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                icon: const Icon(
                  Icons.send_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                onPressed: onSend,
              ),
              IconButton(
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                icon: const Icon(
                  Icons.mic_none_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: onMicTap,
              ),
              IconButton(
                splashRadius: 20,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                icon: const Icon(
                  Icons.attach_file_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: onAttachmentTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

