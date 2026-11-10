import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
import 'package:alexa/features/notes/domain/models/note_model.dart';
import 'package:alexa/features/notes/presentation/widgets/notes_header.dart';
import 'package:alexa/features/notes/presentation/widgets/notes_search_bar.dart';
import 'package:alexa/features/notes/presentation/widgets/notes_tags_filter.dart';
import 'package:alexa/features/notes/presentation/widgets/note_card.dart';
import 'package:alexa/features/notes/presentation/widgets/notes_add_fab.dart';
import 'package:alexa/features/notes/presentation/widgets/sheets/category_picker_sheet.dart';
import 'package:alexa/features/notes/presentation/widgets/sheets/matkul_picker_sheet.dart';
import 'package:alexa/features/notes/presentation/widgets/sheets/note_editor_sheet.dart';

// Re-export domain model & enum untuk kompatibilitas import luar
export 'package:alexa/features/notes/domain/models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTag = 'Semua';

  final List<String> _tags = [
    'Semua',
    'Kuliah',
    'Ide',
    'Tech',
    'Rapat',
    'Pribadi',
  ];

  final List<String> _matkulList = [
    'Algoritma & Pemrograman',
    'Basis Data',
    'Rekayasa Perangkat Lunak',
    'Jaringan Komputer',
    'Kalkulus',
    'Struktur Data',
    'Pemrograman Mobile',
    'Kecerdasan Buatan',
    'Sistem Operasi',
    'Statistika & Probabilitas',
  ];

  final List<NoteModel> _notes = [
    NoteModel(
      id: '1',
      title: 'Rangkuman REST API & Clean Architecture',
      content:
          'Kombinasi FastAPI dengan Pydantic v2 untuk DTO validation. Pisahkan domain entity, repository pattern, dan use-case layer agar mudah di-test.',
      tags: ['Tech', 'Ide'],
      date: '1 jam lalu',
      accentColor: AppColors.info,
      category: NoteCategory.tech,
    ),
    NoteModel(
      id: '2',
      title: 'Pertemuan 5 — Normalisasi Basis Data',
      content:
          '1NF: kolom atomik. 2NF: hilangkan partial dependency. 3NF: hilangkan transitive dependency. BCNF adalah superset dari 3NF. Contoh: relasi Mahasiswa-MK.',
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
      tags: ['Ide', 'Tech'],
      date: '2 hari lalu',
      accentColor: AppColors.purple,
      category: NoteCategory.ide,
    ),
    NoteModel(
      id: '4',
      title: 'Pertemuan 3 — Sorting Algorithms',
      content:
          'Bubble Sort O(n²), Merge Sort O(n log n), Quick Sort O(n log n) avg. Gunakan Merge Sort untuk data besar & stabil. In-place vs Out-of-place.',
      tags: ['Kuliah'],
      date: '2 hari lalu',
      accentColor: AppColors.success,
      category: NoteCategory.kuliah,
      matkul: 'Struktur Data',
    ),
    NoteModel(
      id: '5',
      title: 'Daftar Buku Produktivitas',
      content:
          '1. Atomic Habits — James Clear.\n2. Deep Work — Cal Newport.\n3. Building a Second Brain — Tiago Forte.',
      tags: ['Pribadi'],
      date: '3 hari lalu',
      accentColor: AppColors.warning,
      category: NoteCategory.pribadi,
    ),
    NoteModel(
      id: '6',
      title: 'Konfigurasi RLS Supabase',
      content:
          'Pastikan auth.uid() = user_id pada setiap policy table tasks, notes, dan calendar_events demi privasi mutlak.',
      tags: ['Tech'],
      date: '4 hari lalu',
      accentColor: AppColors.primaryOrangeLight,
      category: NoteCategory.tech,
    ),
  ];

  List<NoteModel> get _filteredNotes {
    final query = _searchController.text.toLowerCase();
    return _notes.where((note) {
      final matchesTag = _selectedTag == 'Semua' ||
          note.tags.contains(_selectedTag) ||
          (_selectedTag == 'Kuliah' && note.category == NoteCategory.kuliah);
      final matchesQuery = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          (note.matkul?.toLowerCase().contains(query) ?? false);
      return matchesTag && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── FAB — pilih kategori ──────────────────────────────────────────────────
  void _showAddNoteFlow() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => CategoryPickerSheet(
        onCategorySelected: (cat) {
          Navigator.pop(ctx);
          if (cat == NoteCategory.kuliah) {
            _showMatkulPicker();
          } else {
            _showNoteEditor(category: cat, matkul: null);
          }
        },
      ),
    );
  }

  // ─── Step 2a (Kuliah): pilih matkul ───────────────────────────────────────
  void _showMatkulPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => MatkulPickerSheet(
        matkulList: _matkulList,
        onMatkulSelected: (matkul) {
          Navigator.pop(ctx);
          _showNoteEditor(category: NoteCategory.kuliah, matkul: matkul);
        },
        onAddMatkul: (newMatkul) {
          setState(() => _matkulList.add(newMatkul));
          Navigator.pop(ctx);
          _showNoteEditor(category: NoteCategory.kuliah, matkul: newMatkul);
        },
      ),
    );
  }

  // ─── Step 3: editor catatan ────────────────────────────────────────────────
  void _showNoteEditor({required NoteCategory category, String? matkul}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => NoteEditorSheet(
        category: category,
        matkul: matkul,
        onSave: (note) {
          setState(() => _notes.insert(0, note));
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Catatan berhasil disimpan ✓'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const NotesHeader(),
            NotesSearchBar(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchController.clear();
                setState(() {});
              },
            ),
            NotesTagsFilter(
              tags: _tags,
              selectedTag: _selectedTag,
              onTagSelected: (tag) => setState(() => _selectedTag = tag),
            ),
            Expanded(child: _buildNotesList()),
          ],
        ),
      ),
      floatingActionButton: NotesAddFab(onTap: _showAddNoteFlow),
    );
  }

  Widget _buildNotesList() {
    final notes = _filteredNotes;

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notes_rounded,
              size: 48,
              color: AppColors.textMuted.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada catatan',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ketuk + untuk mulai menulis',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteCard(note: notes[index]),
    );
  }
}
