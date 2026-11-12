import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/core/theme/theme_controller.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';
import 'package:alexa/features/notes/presentation/widgets/notes_header.dart';
import 'package:alexa/features/notes/presentation/widgets/stacked_paper_note_canvas.dart';
import 'package:alexa/features/notes/presentation/widgets/note_card.dart';
import 'package:alexa/features/notes/presentation/widgets/notes_add_fab.dart';
import 'package:alexa/features/notes/presentation/screens/dot_grid_note_editor_screen.dart';

// Re-export domain model & enum untuk kompatibilitas import luar
export 'package:alexa/features/notes/domain/models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _themeController;
  late final Animation<double> _themeAnim;

  String _selectedCategory = 'Notes';

  @override
  void initState() {
    super.initState();
    _themeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: ThemeController.instance.isDarkMode ? 0.0 : 1.0,
    );
    _themeAnim = CurvedAnimation(
      parent: _themeController,
      curve: Curves.easeInOutCubic,
    );
    ThemeController.instance.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (ThemeController.instance.isDarkMode) {
      _themeController.reverse();
    } else {
      _themeController.forward();
    }
  }

  final List<NoteModel> _notes = [
    NoteModel(
      id: 'hero',
      title: 'The Sprint Design Process',
      content:
          'is a quick, five-day method for teams to prototype and test ideas. Each day focuses on a key phase: understanding the problem, sketching solutions, selecting the best ideas, prototyping, and testing with users. This approach encourages collaboration and rapid feedback, enabling effective design iterations.',
      tags: ['Notes', 'Ide'],
      date: 'Baru saja',
      accentColor: const Color(0xFF0284C7),
      category: NoteCategory.ide,
      isPinned: true,
    ),
    NoteModel(
      id: '1',
      title: 'Rangkuman REST API & Clean Architecture',
      content:
          'Kombinasi FastAPI dengan Pydantic v2 untuk DTO validation. Pisahkan domain entity, repository pattern, dan use-case layer agar mudah di-test.',
      tags: ['Kuliah', 'Tech'],
      date: '1 jam lalu',
      accentColor: AppColors.info,
      category: NoteCategory.kuliah,
    ),
    NoteModel(
      id: '2',
      title: 'Pertemuan 5 — Normalisasi Basis Data',
      content:
          '1NF: kolom atomik. 2NF: hilangkan partial dependency. 3NF: hilangkan transitive dependency. BCNF adalah superset dari 3NF.',
      tags: ['Kuliah'],
      date: 'Kemarin',
      accentColor: AppColors.primaryOrange,
      category: NoteCategory.kuliah,
      matkul: 'Basis Data',
    ),
    NoteModel(
      id: '3',
      title: 'Ide Fitur Alexa AI (Second Brain)',
      content:
          'Pengguna bisa tanya "Kapan terakhir kali aku meeting dengan tim backend?". Gemini memanggil query embedding pgvector untuk semantic retrieval.',
      tags: ['Ide', 'Artwork'],
      date: '2 hari lalu',
      accentColor: AppColors.purple,
      category: NoteCategory.ide,
    ),
    NoteModel(
      id: '4',
      title: 'Pertemuan 3 — Sorting Algorithms',
      content:
          'Bubble Sort O(n²), Merge Sort O(n log n), Quick Sort O(n log n) avg. Gunakan Merge Sort untuk data besar & stabil.',
      tags: ['Kuliah'],
      date: '2 hari lalu',
      accentColor: AppColors.success,
      category: NoteCategory.kuliah,
      matkul: 'Struktur Data',
    ),
  ];

  List<NoteModel> get _filteredNotes {
    if (_selectedCategory == 'Notes') {
      return _notes;
    }
    return _notes.where((n) {
      if (_selectedCategory == 'Kuliah') return n.category == NoteCategory.kuliah;
      if (_selectedCategory == 'Artwork') return n.tags.contains('Artwork') || n.category == NoteCategory.ide;
      if (_selectedCategory == 'Ide') return n.category == NoteCategory.ide;
      return true;
    }).toList();
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    _themeController.dispose();
    super.dispose();
  }

  void _openEditor({NoteModel? note}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, anim, secondaryAnim) => DotGridNoteEditorScreen(
          initialNote: note,
          onSave: (savedNote) {
            setState(() {
              final index = _notes.indexWhere((n) => n.id == savedNote.id);
              if (index != -1) {
                _notes[index] = savedNote;
              } else {
                _notes.insert(0, savedNote);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Catatan berhasil diperbarui ✓'),
                backgroundColor: Color(0xFF10B981),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        transitionsBuilder: (context, anim, secondaryAnim, child) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showAiEditSheet(NoteModel note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2433) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF6366F1)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AI Assist & Polish',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildAiOptionTile(
                icon: Icons.summarize_outlined,
                title: 'Rangkum Intisari Paling Penting',
                subtitle: 'Buat 3 bullet point actionable dari tulisan ini',
                isDark: isDark,
                onTap: () {
                  Navigator.pop(ctx);
                  _openEditor(
                    note: note.copyWith(
                      content: '${note.content}\n\n📌 Intisari AI:\n• Metode 5 hari untuk prototyping cepat\n• Fokus kolaborasi tim & validasi user\n• Mencegah pemborosan waktu pengembangan',
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildAiOptionTile(
                icon: Icons.checklist_rounded,
                title: 'Ekstrak Action Items',
                subtitle: 'Ubah ide menjadi to-do checklist siap eksekusi',
                isDark: isDark,
                onTap: () {
                  Navigator.pop(ctx);
                  _openEditor(
                    note: note.copyWith(
                      content: '${note.content}\n\n✅ To-Do Sprint:\n[ ] Tentukan target sprint\n[ ] Buat sketsa user journey\n[ ] Validasi dengan 5 responden',
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAiOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6366F1)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
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
            const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeAnim,
      builder: (context, _) {
        final t = _themeAnim.value;
        final isDark = t < 0.5;

        final heroNote = _filteredNotes.isNotEmpty ? _filteredNotes.first : null;
        final otherNotes = _filteredNotes.length > 1 ? _filteredNotes.skip(1).toList() : <NoteModel>[];

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-0.8, -0.9),
                end: const Alignment(0.9, 0.95),
                colors: [
                  Color.lerp(const Color(0xFF0C101C), const Color(0xFFF3F4F6), t)!,
                  Color.lerp(const Color(0xFF111728), const Color(0xFFEEF2F6), t)!,
                  Color.lerp(const Color(0xFF18152C), const Color(0xFFF5F7FA), t)!,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ─── Header: Avatar, Squircle Menu, Dual Headline & Tabs ──
                  SliverToBoxAdapter(
                    child: NotesHeader(
                      totalNotes: _filteredNotes.length,
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
                      onMenuTap: () {
                        // Quick switch theme or open settings
                        ThemeController.instance.toggleTheme();
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 18)),

                  // ─── Hero Stacked Paper Note: Catatan Terbaru ─────────────
                  if (heroNote != null)
                    SliverToBoxAdapter(
                      child: StackedPaperNoteCanvas(
                        note: heroNote,
                        onOpen: () => _openEditor(note: heroNote),
                        onNewNoteTap: () => _openEditor(),
                        onBookmarkTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Catatan ditandai penting ✓'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // ─── Catatan Terbaru Section ──────────────────────────────
                  if (otherNotes.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'CATATAN TERBARU',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final note = otherNotes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: NoteCard(
                                note: note,
                                isGrid: false,
                                onTap: () => _openEditor(note: note),
                              ),
                            );
                          },
                          childCount: otherNotes.length,
                        ),
                      ),
                    ),
                  ],

                  // Bottom padding for navigation bar
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
          floatingActionButton: NotesAddFab(
            onTap: () => _openEditor(),
          ),
        );
      },
    );
  }
}
