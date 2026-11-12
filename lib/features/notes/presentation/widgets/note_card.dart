import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final bool isGrid;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    this.isGrid = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Label utama kategori / matkul
    final String? primaryCategoryLabel = note.matkul ?? (note.tags.isNotEmpty ? note.tags.first : null);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isGrid ? 12 : 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2433) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFFE2E8F0).withOpacity(0.9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(isDark ? 0.25 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header: Category Pill (e.g. "Basis Data") & Date ────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (primaryCategoryLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.07)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicator dot sesuai warna aksen catatan
                        Container(
                          width: 6.5,
                          height: 6.5,
                          decoration: BoxDecoration(
                            color: note.accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          primaryCategoryLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.1,
                            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Waktu / Tanggal
                Text(
                  note.date,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ─── Note Title ──────────────────────────────────────────────────
            Text(
              note.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isGrid ? 14.5 : 15.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.2,
                height: 1.25,
              ),
              maxLines: isGrid ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 7),

            // ─── Note Content Snippet ─────────────────────────────────────────
            Text(
              note.content,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
              maxLines: isGrid ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // ─── Bottom Sub-Tags (if multiple tags) ───────────────────────────
            if (note.tags.length > 1)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: note.tags.skip(1).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.04)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$tag',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
