import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alexa/core/theme/theme_controller.dart';

/// Roller Drum / Wheel Time Picker khas Samsung One UI
/// Menampilkan silinder putar angka jam dan menit secara vertikal,
/// lengkap dengan titik pemisah '.' dan chip waktu pintas.
class SamsungTimeWheelPicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final ValueChanged<TimeOfDay> onChanged;

  const SamsungTimeWheelPicker({
    super.key,
    this.initialHour = 14,
    this.initialMinute = 0,
    required this.onChanged,
  });

  @override
  State<SamsungTimeWheelPicker> createState() => _SamsungTimeWheelPickerState();
}

class _SamsungTimeWheelPickerState extends State<SamsungTimeWheelPicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute ~/ 5);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(TimeOfDay(hour: _selectedHour, minute: _selectedMinute));
  }

  void _setTime(int hour, int minute) {
    setState(() {
      _selectedHour = hour;
      _selectedMinute = minute;
    });
    _hourController.animateToItem(
      hour,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
    _minuteController.animateToItem(
      minute ~/ 5,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── Dual Wheel Scroll Area (Jam . Menit) ───────────────────────────
        SizedBox(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kolom Jam (00 - 23)
              SizedBox(
                width: 70,
                child: ListWheelScrollView.useDelegate(
                  controller: _hourController,
                  itemExtent: 44,
                  perspective: 0.003,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() => _selectedHour = index % 24);
                    _notifyChange();
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final hour = index % 24;
                      final isSelected = hour == _selectedHour;
                      return Center(
                        child: Text(
                          hour.toString().padLeft(2, '0'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isSelected ? 26 : 20,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : (isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
                          ),
                        ),
                      );
                    },
                    childCount: 24,
                  ),
                ),
              ),

              // Titik Pembatas Jam dan Menit '.'
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                  ),
                ),
              ),

              // Kolom Menit (00 - 55 per 5 menit)
              SizedBox(
                width: 70,
                child: ListWheelScrollView.useDelegate(
                  controller: _minuteController,
                  itemExtent: 44,
                  perspective: 0.003,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() => _selectedMinute = (index % 12) * 5);
                    _notifyChange();
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final minute = (index % 12) * 5;
                      final isSelected = minute == _selectedMinute;
                      return Center(
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isSelected ? 26 : 20,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : (isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
                          ),
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ─── Quick Shortcuts Chips (Sesuai Gambar 1) ───────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickChip(
                label: '1 jam dari sekarang',
                onTap: () {
                  final nextHour = (DateTime.now().hour + 1) % 24;
                  _setTime(nextHour, 0);
                },
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildQuickChip(
                label: '07.00',
                onTap: () => _setTime(7, 0),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildQuickChip(
                label: '15.00',
                onTap: () => _setTime(15, 0),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickChip({
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2433) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            width: 1.1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}

