import 'package:flutter/material.dart';

class AlexaInsightBanner extends StatelessWidget {
  final Color cardBg;
  final Color accentColor;
  final LinearGradient accentGradient;
  final Color accentLight;
  final Color textSecondary;
  final String? customMessage;

  const AlexaInsightBanner({
    super.key,
    required this.cardBg,
    required this.accentColor,
    required this.accentGradient,
    required this.accentLight,
    required this.textSecondary,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: accentGradient,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, color: textSecondary, height: 1.4),
                children: [
                  TextSpan(
                    text: 'Saran Alexa: ',
                    style: TextStyle(fontWeight: FontWeight.w700, color: accentLight),
                  ),
                  TextSpan(
                    text: customMessage ?? 'Selesaikan tugas klien PT Maju sebelum jam 14:00 karena ada agenda evaluasi meeting offline setelahnya.',
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

