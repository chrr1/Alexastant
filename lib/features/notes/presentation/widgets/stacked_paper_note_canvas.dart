import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';

/// Kartu Catatan Terbaru bergaya Lembaran Kertas Bertumpuk (Tactile Stationery).
/// Menampilkan preview catatan yang paling baru dibuat atau diperbarui,
/// lengkap dengan efek stabilo pastel cyan dan tombol buka catatan.
class StackedPaperNoteCanvas extends StatelessWidget {
  final NoteModel? note;
  final VoidCallback? onOpen;
  final VoidCallback? onAiEdit;
  final VoidCallback? onNewNoteTap;
  final VoidCallback? onBookmarkTap;

  const StackedPaperNoteCanvas({
    super.key,
    this.note,
    this.onOpen,
    this.onAiEdit,
    this.onNewNoteTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title = note?.title ?? 'Catatan Terbaru';
    final content = note?.content ??
        'Belum ada catatan yang ditulis. Ketuk di sini untuk mulai membuat catatan pertamamu di atas kanvas bertitik.';
    final categoryLabel = note?.matkul != null
        ? '${note?.matkul}'
        : (note?.tags.isNotEmpty == true ? note!.tags.first : 'Catatan Terbaru');
    final dateLabel = note?.date ?? 'Baru saja';

    // Estimasi kata
    final wordCount = content.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ─── Angled Paper Layer Underneath (Efek Tumpukan Kertas Fisik) ───
          Positioned(
            left: 8,
            right: 8,
            top: 10,
            bottom: -6,
            child: Transform.rotate(
              angle: 0.036, // Rotasi miring ~2 derajat alami
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2433) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFFE2E8F0),
                    width: 1.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Main Stationery White Paper Sheet ───────────────────────────
          GestureDetector(
            onTap: onOpen,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181F2E) : Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.10)
                      : const Color(0xFFE2E8F0).withOpacity(0.9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(isDark ? 0.35 : 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Top Header: Badge Status & Waktu Terakhir Diedit ─────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: note?.accentColor ?? const Color(0xFF0284C7),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              categoryLabel,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      const Spacer(),
                      // Expand / Open icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.06)
                              : const Color(0xFFF8FAFC),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.open_in_full_rounded,
                          size: 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ─── Note Title ──────────────────────────────────────────
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ─── Note Content Highlight Block (Cyan Stabilo Pastel) ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0284C7).withOpacity(0.18)
                          : const Color(0xFFBAE6FD).withOpacity(0.60), // Soft cyan highlighter
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ─── Bottom Info & Read More Button ──────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Word count / read estimate
                      Row(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 14,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$wordCount kata',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),

                      // Matte Black Pill "Buka Catatan ↗"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Buka Catatan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF111111) : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 13,
                              color: isDark ? const Color(0xFF111111) : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Right Floating Side Tools (Quill & Bookmark Squircles) ──────
          Positioned(
            right: -14,
            top: -20,
            child: Column(
              children: [
                // Feather Quill / Tulis Catatan Baru
                GestureDetector(
                  onTap: onNewNoteTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2433) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.12)
                            : const Color(0xFFE2E8F0),
                        width: 1.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.edit_note_rounded,
                        size: 20,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Document / Bookmark
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2433) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.12)
                            : const Color(0xFFE2E8F0),
                        width: 1.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.bookmark_border_rounded,
                        size: 18,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
