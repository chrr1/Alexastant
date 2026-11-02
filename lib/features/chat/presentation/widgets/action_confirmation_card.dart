import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ActionConfirmationCard extends StatelessWidget {
  final String title;
  final String dateSubtitle;
  final String description;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ActionConfirmationCard({
    super.key,
    this.title = 'Meeting with Team',
    this.dateSubtitle = 'Monday, 09 September 2024',
    this.description =
        "I hope this email finds you well! It's been a while since we last caught up, and I wanted to check in and see how you're doing..",
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Request',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See details',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Main Card Container
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Event Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateSubtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrangeSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.videocam_rounded,
                      color: AppColors.primaryOrangeLight,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Description : ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(
                      text: description,
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surfaceSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          elevation: 6,
                          shadowColor: AppColors.primaryOrangeGlow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Timestamp
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              '11:45',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

