import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesTagsFilter extends StatelessWidget {
  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  const NotesTagsFilter({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final tag = tags[index];
            final isSelected = tag == selectedTag;

            return GestureDetector(
              onTap: () => onTagSelected(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF2563EB), // Sapphire
                            Color(0xFF4F46E5), // Indigo
                          ],
                        )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.white.withOpacity(0.65)),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white.withOpacity(0.88)),
                    width: 1.1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: const Color(0xFF1E293B).withOpacity(0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

