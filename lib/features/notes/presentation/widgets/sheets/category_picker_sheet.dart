import 'package:flutter/material.dart';
import 'package:alexa/core/constants/app_colors.dart';
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
      AppColors.primaryOrange
    ),
    (
      NoteCategory.ide,
      Icons.lightbulb_rounded,
      'Ide & Inspirasi',
      'Catat gagasan sebelum hilang',
      AppColors.warning
    ),
    (
      NoteCategory.tech,
      Icons.code_rounded,
      'Tech & Dev',
      'Snippet, config, dokumentasi',
      AppColors.info
    ),
    (
      NoteCategory.rapat,
      Icons.groups_rounded,
      'Rapat',
      'Notulensi & keputusan',
      AppColors.purple
    ),
    (
      NoteCategory.pribadi,
      Icons.person_rounded,
      'Pribadi',
      'Jurnal & catatan harian',
      AppColors.success
    ),
    (
      NoteCategory.lainnya,
      Icons.more_horiz_rounded,
      'Lainnya',
      'Kategori umum',
      AppColors.textSecondary
    ),
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
                  horizontal: 16,
                  vertical: 14,
                ),
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
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
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

