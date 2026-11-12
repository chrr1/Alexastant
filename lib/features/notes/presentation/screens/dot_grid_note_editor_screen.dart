import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';
import 'package:alexa/features/notes/presentation/widgets/dot_grid_paper_painter.dart';

enum NoteEditorTool {
  pen,
  marker,
  mic,
}

class DotGridNoteEditorScreen extends StatefulWidget {
  final NoteModel? initialNote;
  final ValueChanged<NoteModel> onSave;

  const DotGridNoteEditorScreen({
    super.key,
    this.initialNote,
    required this.onSave,
  });

  @override
  State<DotGridNoteEditorScreen> createState() => _DotGridNoteEditorScreenState();
}

class _DotGridNoteEditorScreenState extends State<DotGridNoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  NoteEditorTool _activeTool = NoteEditorTool.pen;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.initialNote?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final note = (widget.initialNote != null)
        ? widget.initialNote!.copyWith(
            title: title.isEmpty ? 'Catatan Tanpa Judul' : title,
            content: content,
            date: 'Baru saja',
          )
        : NoteModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title.isEmpty ? 'Catatan Baru' : title,
            content: content,
            tags: ['Notes'],
            date: 'Baru saja',
            category: NoteCategory.ide,
          );

    widget.onSave(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              // ─── Header Mini Bar ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Editor Kanvas',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer pengganti agar title center
                ],
              ),

              const SizedBox(height: 10),

              // ─── Dot Grid Paper Canvas (Physical Notebook Pad) ────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2433) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(isDark ? 0.4 : 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // ─── Dot Grid Texture ─────────────────────────────────
                      Positioned.fill(
                        child: CustomPaint(
                          painter: DotGridPaperPainter(
                            dotColor: isDark
                                ? Colors.white.withOpacity(0.08)
                                : const Color(0xFFCBD5E1),
                            spacing: 22.0,
                            dotRadius: 1.2,
                          ),
                        ),
                      ),

                      // ─── Notebook Content & Toolbar ───────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ─── Top Tools Row (Pen, Marker, Mic, Fullscreen)
                            Row(
                              children: [
                                _buildToolButton(
                                  tool: NoteEditorTool.pen,
                                  icon: Icons.edit_outlined,
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 12),
                                _buildToolButton(
                                  tool: NoteEditorTool.marker,
                                  icon: Icons.brush_outlined,
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 12),
                                _buildToolButton(
                                  tool: NoteEditorTool.mic,
                                  icon: Icons.mic_none_rounded,
                                  isDark: isDark,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : const Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_fullscreen_rounded,
                                      size: 16,
                                      color: isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // ─── Note Title Input ─────────────────────────
                            TextField(
                              controller: _titleController,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                letterSpacing: -0.4,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Judul Catatan...',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w700,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ─── Note Body Input ──────────────────────────
                            Expanded(
                              child: Container(
                                decoration: _isHighlighted
                                    ? BoxDecoration(
                                        color: const Color(0xFFBAE6FD).withOpacity(0.55),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : null,
                                child: TextField(
                                  controller: _contentController,
                                  maxLines: null,
                                  expands: true,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.5,
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? const Color(0xFFE2E8F0)
                                        : const Color(0xFF1E293B),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Tuliskan ide, rangkuman, atau pemikiranmu di sini...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      color: isDark
                                          ? const Color(0xFF475569)
                                          : const Color(0xFF94A3B8),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ─── Bottom Floating Checkmark Button (Save) ──────────
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: GestureDetector(
                          onTap: _handleSave,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white : const Color(0xFF111111),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.24),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check_rounded,
                                size: 26,
                                color: isDark ? const Color(0xFF111111) : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required NoteEditorTool tool,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _activeTool == tool;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTool = tool;
          if (tool == NoteEditorTool.marker) {
            _isHighlighted = !_isHighlighted;
          }
        });
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : const Color(0xFF111111))
              : (isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected
              ? (isDark ? const Color(0xFF0F172A) : Colors.white)
              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
        ),
      ),
    );
  }
}

