import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

enum NoteCategory { kuliah, pribadi, ide, rapat, tech, lainnya }

class NoteModel {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final String date;
  final Color accentColor;
  final NoteCategory category;
  final String? matkul; // only for kuliah category

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.date,
    required this.accentColor,
    this.category = NoteCategory.lainnya,
    this.matkul,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

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
      builder: (ctx) => _CategoryPickerSheet(
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
      builder: (ctx) => _MatkulPickerSheet(
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
      builder: (ctx) => _NoteEditorSheet(
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

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTagsRow(),
            Expanded(child: _buildNotesList()),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catatan & Memori',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tulis manual atau lewat Alexa Voice',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryOrange,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded,
                color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Cari catatan, matkul, atau kata kunci...',
                  hintStyle:
                      TextStyle(color: AppColors.textMuted, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() {});
                },
                child: const Icon(Icons.close_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final tag = _tags[index];
            final isSelected = tag == _selectedTag;
            return GestureDetector(
              onTap: () => setState(() => _selectedTag = tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.white : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.activeChipText
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    final notes = _filteredNotes;

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes_rounded,
                size: 48, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 12),
            const Text(
              'Belum ada catatan',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600),
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
      itemBuilder: (context, index) => _NoteCard(note: notes[index]),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: _showAddNoteFlow,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.orangeGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrangeGlow,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

// ─── Sheet 1: Pilih Kategori ───────────────────────────────────────────────

class _CategoryPickerSheet extends StatelessWidget {
  final void Function(NoteCategory) onCategorySelected;

  const _CategoryPickerSheet({required this.onCategorySelected});

  static const _categories = [
    (NoteCategory.kuliah, Icons.school_rounded, 'Perkuliahan',
        'Catatan dari mata kuliah', AppColors.primaryOrange),
    (NoteCategory.ide, Icons.lightbulb_rounded, 'Ide & Inspirasi',
        'Catat gagasan sebelum hilang', AppColors.warning),
    (NoteCategory.tech, Icons.code_rounded, 'Tech & Dev',
        'Snippet, config, dokumentasi', AppColors.info),
    (NoteCategory.rapat, Icons.groups_rounded, 'Rapat',
        'Notulensi & keputusan', AppColors.purple),
    (NoteCategory.pribadi, Icons.person_rounded, 'Pribadi',
        'Jurnal & catatan harian', AppColors.success),
    (NoteCategory.lainnya, Icons.more_horiz_rounded, 'Lainnya',
        'Kategori umum', AppColors.textSecondary),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih Kategori Catatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Catatan akan dikelompokkan sesuai kategori',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ..._categories.map((cat) {
            final (category, icon, label, subtitle, color) = cat;
            return GestureDetector(
              onTap: () => onCategorySelected(category),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted, size: 20),
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

// ─── Sheet 2: Pilih Mata Kuliah ────────────────────────────────────────────

class _MatkulPickerSheet extends StatefulWidget {
  final List<String> matkulList;
  final void Function(String) onMatkulSelected;
  final void Function(String) onAddMatkul;

  const _MatkulPickerSheet({
    required this.matkulList,
    required this.onMatkulSelected,
    required this.onAddMatkul,
  });

  @override
  State<_MatkulPickerSheet> createState() => _MatkulPickerSheetState();
}

class _MatkulPickerSheetState extends State<_MatkulPickerSheet> {
  final TextEditingController _addCtrl = TextEditingController();
  bool _showAddField = false;

  @override
  void dispose() {
    _addCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 32 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // back + title
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary, size: 15),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Mata Kuliah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Catatan akan ditagging sesuai matkul',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // matkul list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.matkulList.length,
              itemBuilder: (context, index) {
                final mk = widget.matkulList[index];
                return GestureDetector(
                  onTap: () => widget.onMatkulSelected(mk),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryOrange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.menu_book_rounded,
                              color: AppColors.primaryOrange, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            mk,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.textMuted, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // add matkul baru
          if (!_showAddField)
            GestureDetector(
              onTap: () => setState(() => _showAddField = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primaryOrange.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded,
                        color: AppColors.primaryOrange, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Mata Kuliah Baru',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryOrange),
                    ),
                    child: TextField(
                      controller: _addCtrl,
                      autofocus: true,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Nama mata kuliah...',
                        hintStyle: TextStyle(
                            color: AppColors.textMuted, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final name = _addCtrl.text.trim();
                    if (name.isNotEmpty) widget.onAddMatkul(name);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─── Sheet 3: Editor Catatan ───────────────────────────────────────────────

class _NoteEditorSheet extends StatefulWidget {
  final NoteCategory category;
  final String? matkul;
  final void Function(NoteModel) onSave;

  const _NoteEditorSheet({
    required this.category,
    required this.matkul,
    required this.onSave,
  });

  @override
  State<_NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<_NoteEditorSheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  Color get _accentColor {
    switch (widget.category) {
      case NoteCategory.kuliah:
        return AppColors.primaryOrange;
      case NoteCategory.ide:
        return AppColors.warning;
      case NoteCategory.tech:
        return AppColors.info;
      case NoteCategory.rapat:
        return AppColors.purple;
      case NoteCategory.pribadi:
        return AppColors.success;
      case NoteCategory.lainnya:
        return AppColors.textSecondary;
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
          backgroundColor: AppColors.warning,
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 32 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // top row: back + context badge
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary, size: 15),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tulis Catatan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (widget.matkul != null)
                      Text(
                        '📚 ${widget.matkul}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      )
                    else
                      Text(
                        _categoryLabel,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              // save button
              GestureDetector(
                onTap: _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // category badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _accentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // title field
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.matkul != null
                  ? 'Judul catatan / pertemuan ke-...'
                  : 'Judul catatan...',
              hintStyle:
                  const TextStyle(color: AppColors.textMuted, fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Divider(color: AppColors.cardBorder, height: 20),
          // content field
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.28,
            ),
            child: TextField(
              controller: _contentCtrl,
              maxLines: null,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: widget.matkul != null
                    ? 'Tulis ringkasan materi, definisi, atau catatan penting...'
                    : 'Tulis catatan kamu di sini...',
                hintStyle:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13),
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

// ─── Note Card ────────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: note.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          // matkul badge if applicable
          if (note.matkul != null) ...[
            const SizedBox(height: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_rounded,
                      color: AppColors.primaryOrange, size: 10),
                  const SizedBox(width: 4),
                  Text(
                    note.matkul!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            note.content,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: note.tags.map((tag) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: note.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: note.accentColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
              Text(
                note.date,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
