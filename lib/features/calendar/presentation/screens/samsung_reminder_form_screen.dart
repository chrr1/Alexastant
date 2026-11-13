import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';
import 'package:alexa/features/calendar/domain/models/calendar_event_model.dart';
import 'package:alexa/features/calendar/domain/calendar_samsung_data.dart';
import 'package:alexa/features/calendar/presentation/widgets/samsung_time_wheel_picker.dart';
import 'package:alexa/features/calendar/presentation/widgets/samsung_category_picker_sheet.dart';

class SamsungReminderFormScreen extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<CalendarEventItem> onSave;

  const SamsungReminderFormScreen({
    super.key,
    required this.initialDate,
    required this.onSave,
  });

  @override
  State<SamsungReminderFormScreen> createState() => _SamsungReminderFormScreenState();
}

class _SamsungReminderFormScreenState extends State<SamsungReminderFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isFavorite = false;
  bool _isAllDay = false;
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  String _repeatRule = 'Jangan ulangi';
  String _reminderLevel = 'Sedang';

  CalendarCategoryItem _selectedCategory = CalendarSamsungData.getDefaultCategories().first;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _openCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.75,
        child: SamsungCategoryPickerSheet(
          selectedCategoryId: _selectedCategory.id,
          onCategorySelected: (cat) {
            setState(() => _selectedCategory = cat);
          },
        ),
      ),
    );
  }

  void _showRepeatPicker() {
    final options = ['Jangan ulangi', 'Setiap hari', 'Setiap minggu', 'Setiap bulan', 'Setiap tahun'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = ThemeController.instance.isDarkMode;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2433) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((opt) {
              return ListTile(
                title: Text(
                  opt,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: opt == _repeatRule ? FontWeight.w700 : FontWeight.w500,
                    color: opt == _repeatRule
                        ? (isDark ? Colors.white : const Color(0xFF3B82F6))
                        : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
                  ),
                ),
                trailing: opt == _repeatRule
                    ? Icon(Icons.check_rounded, color: isDark ? Colors.white : const Color(0xFF3B82F6))
                    : null,
                onTap: () {
                  setState(() => _repeatRule = opt);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan judul pengingat'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final formattedTime = _isAllDay
        ? 'Sepanjang hari'
        : '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    final newEvent = CalendarEventItem(
      id: 'event_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      date: _selectedDate,
      time: formattedTime,
      location: _locationController.text.trim(),
      color: _selectedCategory.color,
      category: _selectedCategory.name,
      isAllDay: _isAllDay,
      repeatRule: _repeatRule,
      reminderLevel: _reminderLevel,
    );

    widget.onSave(newEvent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    final formattedDateText = '${_selectedDate.day} Okt';
    final formattedTimeText =
        '${_selectedTime.hour.toString().padLeft(2, '0')}.${_selectedTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Bar: Judul + Star Favorite ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pengingat baru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                    icon: Icon(
                      _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 26,
                      color: _isFavorite
                          ? const Color(0xFFF59E0B)
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Scrollable Form Cards ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // ─── 1. Card Input Judul ─────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161A23) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark ? const Color(0xFF262C3A) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            autofocus: true,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Judul',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 22,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 14),
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 22,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── 2. Card Waktu (Collapsible Card Sesuai Gambar 1) ────
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161A23) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark ? const Color(0xFF262C3A) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Waktu + Close X
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: isDark ? Colors.white70 : const Color(0xFF475569),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Waktu',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          Divider(
                            height: 1,
                            color: isDark ? const Color(0xFF262C3A) : const Color(0xFFF1F5F9),
                          ),
                          const SizedBox(height: 14),

                          // Toggle Sepanjang Hari
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 18,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Sepanjang hari',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isAllDay,
                                onChanged: (val) => setState(() => _isAllDay = val),
                                activeColor: isDark ? Colors.white : const Color(0xFF3B82F6),
                              ),
                            ],
                          ),

                          if (!_isAllDay) ...[
                            const SizedBox(height: 14),
                            // Pill Hari ini | Jam
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF222838) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    formattedDateText,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF222838) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    formattedTimeText,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Drum Roller Wheel Picker
                            SamsungTimeWheelPicker(
                              initialHour: _selectedTime.hour,
                              initialMinute: _selectedTime.minute,
                              onChanged: (newTime) {
                                setState(() => _selectedTime = newTime);
                              },
                            ),
                          ],

                          const SizedBox(height: 16),
                          Divider(
                            height: 1,
                            color: isDark ? const Color(0xFF262C3A) : const Color(0xFFF1F5F9),
                          ),
                          const SizedBox(height: 14),

                          // Opsi Jangan Ulangi
                          InkWell(
                            onTap: _showRepeatPicker,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.repeat_rounded,
                                  size: 18,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _repeatRule,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Opsi Nada Pengingat (Sedang)
                          Row(
                            children: [
                              Icon(
                                Icons.volume_up_outlined,
                                size: 18,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _reminderLevel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── 3. Card Kategori Pilihan (Menghubungkan ke Gambar 2) ─
                    GestureDetector(
                      onTap: _openCategoryPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF161A23) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isDark ? const Color(0xFF262C3A) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: _selectedCategory.color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_selectedCategory.icon, size: 14, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedCategory.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── 4. Card Tempat ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161A23) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark ? const Color(0xFF262C3A) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 19,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _locationController,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Tempat / Lokasi',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── Sticky Bottom Action Bar (Batalkan / Simpan) ────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0C101A) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? const Color(0xFF262C3A) : const Color(0xFFE2E8F0),
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batalkan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _handleSave,
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

