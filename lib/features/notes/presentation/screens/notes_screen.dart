import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final String date;
  final Color accentColor;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.date,
    required this.accentColor,
  });
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTag = 'Semua';

  final List<String> _tags = ['Semua', 'Ide', 'Tech', 'Rapat', 'Pribadi', 'Buku'];

  final List<NoteModel> _notes = [
    NoteModel(
      id: '1',
      title: 'Materi REST API & Clean Architecture',
      content:
          'Kombinasi FastAPI dengan Pydantic v2 untuk DTO validation. Pisahkan domain entity, repository pattern, dan use-case.',
      tags: ['Tech', 'Ide'],
      date: '1 jam lalu',
      accentColor: AppColors.info,
    ),
    NoteModel(
      id: '2',
      title: 'Catatan Evaluasi Klien PT Maju',
      content:
          'Poin utama rapat: 1. Perpanjangan masa support. 2. Integrasi webhook kalender otomatis. 3. Target testing minggu depan.',
      tags: ['Rapat'],
      date: 'Kemarin',
      accentColor: AppColors.primaryOrange,
    ),
    NoteModel(
      id: '3',
      title: 'Ide Fitur Alexa AI (Second Brain)',
      content:
          'Pengguna bisa tanya "Kapan terakhir kali aku meeting dengan tim backend?". Gemini memanggil query embedding pgvector.',
      tags: ['Ide', 'Tech'],
      date: '2 hari lalu',
      accentColor: AppColors.purple,
    ),
    NoteModel(
      id: '4',
      title: 'Daftar Buku Produktivitas',
      content:
          '1. Atomic Habits - James Clear.\n2. Deep Work - Cal Newport.\n3. Building a Second Brain - Tiago Forte.',
      tags: ['Buku', 'Pribadi'],
      date: '3 hari lalu',
      accentColor: AppColors.success,
    ),
    NoteModel(
      id: '5',
      title: 'Konfigurasi Supabase Row Level Security',
      content:
          'Pastikan auth.uid() = user_id pada setiap policy table tasks, notes, dan calendar_events demi privasi mutlak.',
      tags: ['Tech'],
      date: '4 hari lalu',
      accentColor: AppColors.warning,
    ),
    NoteModel(
      id: '6',
      title: 'Resep Bumbu Rendang Nenek',
      content:
          'Bawang merah, bawang putih, lengkuas, santan kental 1 liter, daun kunyit, daun jeruk, serai, cabai giling halus.',
      tags: ['Pribadi'],
      date: '1 minggu lalu',
      accentColor: AppColors.primaryOrangeLight,
    ),
  ];

  List<NoteModel> get _filteredNotes {
    final query = _searchController.text.toLowerCase();
    return _notes.where((note) {
      final matchesTag =
          _selectedTag == 'Semua' || note.tags.contains(_selectedTag);
      final matchesQuery = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
      return matchesTag && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            Expanded(child: _buildNotesGrid()),
          ],
        ),
      ),
      floatingActionButton: _buildAddNoteFab(),
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
                'Second Brain dengan Semantic Search',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
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
            const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari catatan dengan makna / konteks...',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
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
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
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
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildNotesGrid() {
    final notes = _filteredNotes;

    if (notes.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada catatan ditemukan',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _NoteCard(note: note);
      },
    );
  }

  Widget _buildAddNoteFab() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Katakan "Alexa, simpan catatan..." atau ketik di tab Alexa!'),
            backgroundColor: AppColors.primaryOrange,
          ),
        );
      },
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
        child: const Icon(Icons.note_add_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      horizontal: 8,
                      vertical: 3,
                    ),
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
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

