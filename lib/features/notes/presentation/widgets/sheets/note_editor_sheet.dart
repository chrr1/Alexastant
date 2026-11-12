import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';

class NoteEditorSheet extends StatefulWidget {
  final NoteCategory category;
  final String? matkul;
  final void Function(NoteModel) onSave;

  const NoteEditorSheet({
    super.key,
    required this.category,
    required this.matkul,
    required this.onSave,
  });

  @override
  State<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<NoteEditorSheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  Color get _accentColor {
    switch (widget.category) {
      case NoteCategory.kuliah:
        return const Color(0xFF2563EB); // Sapphire
      case NoteCategory.ide:
        return const Color(0xFFF59E0B); // Amber
      case NoteCategory.tech:
        return const Color(0xFF6366F1); // Indigo
      case NoteCategory.rapat:
        return const Color(0xFF8B5CF6); // Purple
      case NoteCategory.pribadi:
        return const Color(0xFF10B981); // Emerald
      case NoteCategory.lainnya:
        return const Color(0xFF64748B); // Slate
    }
  }

  String get _categoryLabel {
    switch (widget.category) {
      case NoteCategory.kuliah:
        return 'Kuliah';
      case NoteCategory.ide:
        return 'Ide';
      case NoteCategory.tech:
        return 'Tech';
      case NoteCategory.rapat:
        return 'Rapat';
      case NoteCategory.pribadi:
        return 'Pribadi';
      case NoteCategory.lainnya:
        return 'Lainnya';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan isi catatan tidak boleh kosong'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final tags = <String>[_categoryLabel];
    final note = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      tags: tags,
      date: 'Baru saja',
      accentColor: _accentColor,
      category: widget.category,
      matkul: widget.matkul,
    );
    widget.onSave(note);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 36 + bottomInset),
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
          const SizedBox(height: 18),

          // ─── Top Row: Back + Context Badge + Save Button ───────────────────
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tulis Catatan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (widget.matkul != null)
                      Text(
                        '📚 ${widget.matkul}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      )
                    else
                      Text(
                        _categoryLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                  ],
                ),
              ),
              // Save button
              GestureDetector(
                onTap: _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF4F46E5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ─── Category Badge ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.matkul ?? _categoryLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _accentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ─── Title Field ───────────────────────────────────────────────────
          TextField(
            controller: _titleCtrl,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: widget.matkul != null
                  ? 'Judul catatan / pertemuan ke-...'
                  : 'Judul catatan...',
              hintStyle: GoogleFonts.plusJakartaSans(
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Divider(
            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
            height: 22,
          ),

          // ─── Content Field ─────────────────────────────────────────────────
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.28,
            ),
            child: TextField(
              controller: _contentCtrl,
              maxLines: null,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: widget.matkul != null
                    ? 'Tulis ringkasan materi, definisi, atau catatan penting...'
                    : 'Tulis catatan kamu di sini...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  fontSize: 13.5,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

