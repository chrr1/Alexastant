import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageNotesDeckCard extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const ImageNotesDeckCard({
    super.key,
    this.count = 5,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2433) : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : const Color(0xFFE2E8F0).withOpacity(0.8),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(isDark ? 0.25 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // ─── Left Details ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Note',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count Image Notes Saved',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Right Deck of Polaroid Photos peeking from Folder ───────
              SizedBox(
                width: 104,
                height: 60,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerRight,
                  children: [
                    // Polaroid 1 (Leftmost, rotated -14 deg)
                    Positioned(
                      right: 48,
                      bottom: 10,
                      child: Transform.rotate(
                        angle: -14 * math.pi / 180,
                        child: _buildMiniPolaroid(
                          color: const Color(0xFFE0E7FF),
                          imageTag: 'P1',
                          accent: const Color(0xFF4F46E5),
                        ),
                      ),
                    ),

                    // Polaroid 2 (Rightmost, rotated +16 deg)
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Transform.rotate(
                        angle: 16 * math.pi / 180,
                        child: _buildMiniPolaroid(
                          color: const Color(0xFFFEF3C7),
                          imageTag: 'P2',
                          accent: const Color(0xFFD97706),
                        ),
                      ),
                    ),

                    // Polaroid 3 (Center, slightly rotated +2 deg)
                    Positioned(
                      right: 28,
                      bottom: 8,
                      child: Transform.rotate(
                        angle: 2 * math.pi / 180,
                        child: _buildMiniPolaroid(
                          color: const Color(0xFFFFEDD5),
                          imageTag: 'P3',
                          accent: const Color(0xFFEA580C),
                        ),
                      ),
                    ),

                    // Folder Envelope in front
                    Positioned(
                      right: 0,
                      bottom: -4,
                      child: Container(
                        width: 90,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2B3448) : const Color(0xFFF1F5F9),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.12)
                                : const Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mini sticker badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.14),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.photo_library_outlined,
                                    size: 11,
                                    color: Color(0xFFDC2626),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'GALLERY',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFF38BDF8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.star_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniPolaroid({
    required Color color,
    required String imageTag,
    required Color accent,
  }) {
    return Container(
      width: 38,
      height: 48,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 14,
                  color: accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 2,
            width: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

