import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';
import 'package:alexa/features/calendar/domain/calendar_samsung_data.dart';

class SamsungCategoryPickerSheet extends StatefulWidget {
  final String selectedCategoryId;
  final ValueChanged<CalendarCategoryItem> onCategorySelected;

  const SamsungCategoryPickerSheet({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<SamsungCategoryPickerSheet> createState() => _SamsungCategoryPickerSheetState();
}

class _SamsungCategoryPickerSheetState extends State<SamsungCategoryPickerSheet> {
  late List<CalendarCategoryItem> _categories;
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _categories = CalendarSamsungData.getDefaultCategories();
    _selectedId = widget.selectedCategoryId;
  }

  void _showAddCategoryDialog() {
    final textController = TextEditingController();
    Color selectedColor = const Color(0xFF3B82F6);

    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
      const Color(0xFF84CC16),
      const Color(0xFF3B82F6),
      const Color(0xFFEC4899),
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = ThemeController.instance.isDarkMode;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E2433) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text(
              'Tambah kategori',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nama kategori...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Pilih Warna:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: colors.map((c) {
                    final isPicked = c == selectedColor;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = c),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: isPicked ? Border.all(color: Colors.white, width: 2.5) : null,
                          boxShadow: [
                            if (isPicked)
                              BoxShadow(
                                color: c.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Batal',
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = textController.text.trim();
                  if (name.isNotEmpty) {
                    final newCat = CalendarCategoryItem(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      color: selectedColor,
                      icon: Icons.notifications_rounded,
                      count: 0,
                    );
                    setState(() {
                      _categories.add(newCat);
                      _selectedId = newCat.id;
                    });
                    widget.onCategorySelected(newCat);
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Tambah',
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C101A) : const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle Bar Atas
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Top Header: Back Arrow + Pilih Kategori
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
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
                    'Pilih kategori',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // Body List
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label "Semat"
                    Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 8),
                      child: Text(
                        'Semat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),

                    // Main Container Rounded Kategori (Sesuai Gambar 2)
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF181F2E) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? const Color(0xFF262E3E) : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _categories.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 0.8,
                            color: isDark ? const Color(0xFF262E3E) : const Color(0xFFF1F5F9),
                          ),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = cat.id == _selectedId || cat.name == _selectedId;

                            return InkWell(
                              onTap: () {
                                setState(() => _selectedId = cat.id);
                                widget.onCategorySelected(cat);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    // Radio Button Lingkaran Khas Samsung
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? (isDark ? Colors.white : const Color(0xFF3B82F6))
                                              : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                                          width: isSelected ? 6.5 : 1.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Lingkaran Background Warna + Icon
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: cat.color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        cat.icon,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Nama Kategori
                                    Expanded(
                                      child: Text(
                                        cat.name,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),

                                    // Counter Angka di Sebelah Kanan
                                    Text(
                                      '${cat.count}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Tombol "+ Tambah kategori"
                    GestureDetector(
                      onTap: _showAddCategoryDialog,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 22,
                              color: isDark ? Colors.white : const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Tambah kategori',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

