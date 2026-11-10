import 'package:flutter/material.dart';
import '../../../voice/presentation/screens/voice_conversation_screen.dart';

class NextUpCard extends StatelessWidget {
  final Color cardBg;
  final Color cardBorder;
  final Color topBtnBg;
  final Color topIconColor;
  final Color textPrimary;
  final Color textMuted;
  final Color accentColor;
  final double animProgress;
  final String timeText;
  final String title;
  final String location;

  const NextUpCard({
    super.key,
    required this.cardBg,
    required this.cardBorder,
    required this.topBtnBg,
    required this.topIconColor,
    required this.textPrimary,
    required this.textMuted,
    required this.accentColor,
    required this.animProgress,
    this.timeText = '10:00 • 15 menit lagi',
    this.title = 'Kuliah Pemrograman Mobile',
    this.location = 'Lab Komputer 302, Gedung B',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const VoiceConversationScreen(
              transcriptText: 'Alexa, beritahu jadwal kuliah terdekat.',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    cardBg,
                    Colors.white.withOpacity(0.95),
                    animProgress,
                  )!,
                  Color.lerp(
                    cardBg,
                    Colors.white.withOpacity(0.80),
                    animProgress,
                  )!,
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Color.lerp(
                  cardBorder,
                  Colors.white.withOpacity(0.80),
                  animProgress,
                )!,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(animProgress > 0.5 ? 0.07 : 0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: topBtnBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: topIconColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
