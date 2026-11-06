import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';

/// Bar horizontal berisi chip-chip saran prompt yang dapat diklik
/// untuk langsung mengirim pesan tertentu ke Alexa AI.
class SuggestedPromptsBar extends StatelessWidget {
  final List<String> prompts;
  final ValueChanged<String> onPromptTap;

  const SuggestedPromptsBar({
    super.key,
    required this.prompts,
    required this.onPromptTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return GestureDetector(
            onTap: () => onPromptTap(prompt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    size: 13,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    prompt,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

