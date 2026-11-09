import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
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
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 15,
                  ),
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
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      Text(
                        _categoryLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              // save button
              GestureDetector(
                onTap: _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const Divider(color: AppColors.cardBorder, height: 20),
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
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
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

