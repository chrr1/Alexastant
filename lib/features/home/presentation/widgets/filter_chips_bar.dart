import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FilterChipsBar extends StatefulWidget {
  final Function(String category)? onSelected;

  const FilterChipsBar({super.key, this.onSelected});

  @override
  State<FilterChipsBar> createState() => _FilterChipsBarState();
}

class _FilterChipsBarState extends State<FilterChipsBar> {
  final List<String> _categories = [
    'All',
    'Email',
    'Coding',
    'Health',
    'Work',
    'Personal'
  ];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recents',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat == _selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = cat);
                  widget.onSelected?.call(cat);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
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
      ],
    );
  }
}

