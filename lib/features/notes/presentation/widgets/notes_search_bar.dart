import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const NotesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.72),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.92),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(isDark ? 0.20 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: GoogleFonts.plusJakartaSans(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari catatan, matkul, atau kata kunci...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white : const Color(0xFF475569),
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

