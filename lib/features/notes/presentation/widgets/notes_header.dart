import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesHeader extends StatelessWidget {
  final int totalNotes;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback? onMenuTap;
  final VoidCallback? onAvatarTap;

  const NotesHeader({
    super.key,
    required this.totalNotes,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.onMenuTap,
    this.onAvatarTap,
  });

  static const List<String> categories = [
    'Notes',
    'Artwork',
    'Kuliah',
    'Ide',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Top Bar: Avatar & Squircle Menu Button ────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar Profil Karakter
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE047).withOpacity(0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.18) : Colors.white,
                      width: 2.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Center(
                      child: Icon(
                        Icons.face_retouching_natural_rounded,
                        size: 26,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ),
              ),

              // Squircle Menu / Settings Button
              GestureDetector(
                onTap: onMenuTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2433) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu_rounded,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ─── Dual-Weight Editorial Headline ──────────────────────────────
          RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 27,
                height: 1.15,
                letterSpacing: -0.6,
              ),
              children: [
                TextSpan(
                  text: 'Capture ',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                  ),
                ),
                TextSpan(
                  text: 'More.\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: 'Remember ',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                  ),
                ),
                TextSpan(
                  text: 'Better.',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ─── Category Pills ──────────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;

                return GestureDetector(
                  onTap: () => onCategoryChanged(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF111111))
                          : (isDark
                              ? const Color(0xFF1E2433)
                              : Colors.white.withOpacity(0.85)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                ? Colors.white.withOpacity(0.08)
                                : const Color(0xFFE2E8F0)),
                        width: 1.1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
