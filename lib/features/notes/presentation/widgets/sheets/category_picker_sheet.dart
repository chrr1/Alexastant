import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';

class CategoryPickerSheet extends StatelessWidget {
  final void Function(NoteCategory) onCategorySelected;

  const CategoryPickerSheet({super.key, required this.onCategorySelected});

  static const _categories = [
    (
      NoteCategory.kuliah,
      Icons.school_rounded,
      'Perkuliahan',
      'Catatan dari mata kuliah',
      Color(0xFF2563EB), // Sapphire
    ),
    (
      NoteCategory.ide,
      Icons.lightbulb_rounded,
      'Ide & Inspirasi',
      'Catat gagasan sebelum hilang',
      Color(0xFFF59E0B), // Amber
    ),
    (
      NoteCategory.tech,
      Icons.code_rounded,
      'Tech & Dev',
      'Snippet, config, dokumentasi',
      Color(0xFF6366F1), // Indigo
    ),
    (
      NoteCategory.rapat,
      Icons.groups_rounded,
      'Rapat',
      'Notulensi & keputusan tim',
      Color(0xFF8B5CF6), // Purple
    ),
    (
      NoteCategory.pribadi,
      Icons.person_rounded,
      'Pribadi',
      'Jurnal & catatan harian',
      Color(0xFF10B981), // Emerald
    ),
    (
      NoteCategory.lainnya,
      Icons.more_horiz_rounded,
      'Lainnya',
      'Kategori umum bebas',
      Color(0xFF64748B), // Slate
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Handle ────────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.2) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Kategori Catatan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Catatan akan dikelompokkan sesuai kategori memori',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 18),
          ..._categories.map((cat) {
            final (category, icon, label, subtitle, color) = cat;
            return GestureDetector(
              onTap: () => onCategorySelected(category),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

