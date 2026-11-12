import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarTopHeader extends StatelessWidget {
  const CalendarTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ─── Left Profile & Greeting ─────────────────────────────────────────
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1), // Indigo
                    Color(0xFF3B82F6), // Royal Blue
                  ],
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 2.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF6366F1), // Jewel dot
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Good Morning',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Amelia',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ─── Right Frosted Glass Notification Capsule ───────────────────────
        Stack(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.68),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Colors.white.withOpacity(0.92),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E293B).withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: isDark ? Colors.white : const Color(0xFF334155),
                size: 20,
              ),
            ),
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1), // Glowing indigo dot
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

