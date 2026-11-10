import 'package:flutter/material.dart';

class RhythmSoundwaveCard extends StatelessWidget {
  final Color accentColor;
  final double animProgress;

  const RhythmSoundwaveCard({
    super.key,
    required this.accentColor,
    required this.animProgress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      width: double.infinity,
      child: CustomPaint(
        painter: _PillSoundwavePainter(
          accentColor: accentColor,
          animProgress: animProgress,
        ),
      ),
    );
  }
}

/// Paints the iconic vertical capsule/pill soundwave matrix with smooth interpolation.
class _PillSoundwavePainter extends CustomPainter {
  final Color accentColor;
  final double animProgress;

  _PillSoundwavePainter({
    required this.accentColor,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activePaint = Paint()..color = accentColor;
    final mutedColor = Color.lerp(
      const Color(0xFF2E2E36),
      Colors.white.withOpacity(0.72), // Clearly visible pill tracks in light mode
      animProgress,
    )!;
    final mutedPaint = Paint()..color = mutedColor;
    const pillGap = 5.0; // gap between stacked pills in one column
    const colGap = 5.5;  // horizontal gap between columns

    // 22 columns — bottom-anchored Gaussian bell curve.
    final columns = [
      _ColumnData(isAccent: false, pills: [14, 22]),         // col 0  ≈ 41
      _ColumnData(isAccent: false, pills: [26, 38]),         // col 1  ≈ 69
      _ColumnData(isAccent: false, pills: [58]),             // col 2    58
      _ColumnData(isAccent: false, pills: [78]),             // col 3    78
      _ColumnData(isAccent: true,  pills: [36, 52]),         // col 4  ≈ 93
      _ColumnData(isAccent: true,  pills: [22, 32, 30]),     // col 5  ≈ 94
      _ColumnData(isAccent: true,  pills: [58, 48]),         // col 6  ≈ 111
      _ColumnData(isAccent: true,  pills: [30, 76]),         // col 7  ≈ 111
      _ColumnData(isAccent: true,  pills: [42, 26, 40]),     // col 8  ≈ 118
      _ColumnData(isAccent: true,  pills: [124]),            // col 9    124 — peak
      _ColumnData(isAccent: true,  pills: [40, 56]),         // col 10 ≈ 101
      _ColumnData(isAccent: true,  pills: [128]),            // col 11   128 — APEX
      _ColumnData(isAccent: true,  pills: [42, 58]),         // col 12 ≈ 105
      _ColumnData(isAccent: true,  pills: [32, 70]),         // col 13 ≈ 107
      _ColumnData(isAccent: true,  pills: [46, 30, 40]),     // col 14 ≈ 126
      _ColumnData(isAccent: true,  pills: [118]),            // col 15   118
      _ColumnData(isAccent: true,  pills: [34, 52]),         // col 16 ≈ 91
      _ColumnData(isAccent: true,  pills: [62]),             // col 17   62
      _ColumnData(isAccent: false, pills: [38, 30]),         // col 18 ≈ 73
      _ColumnData(isAccent: false, pills: [24, 42]),         // col 19 ≈ 71
      _ColumnData(isAccent: false, pills: [52]),             // col 20   52
      _ColumnData(isAccent: false, pills: [16, 26]),         // col 21 ≈ 47
    ];

    final colWidth =
        (size.width - ((columns.length - 1) * colGap)) / columns.length;

    for (int i = 0; i < columns.length; i++) {
      final col = columns[i];
      final paint = col.isAccent ? activePaint : mutedPaint;
      final x = i * (colWidth + colGap);

      // Sum of all pill heights + gaps between them
      final double totalH = col.pills.fold<double>(0.0, (s, h) => s + h.toDouble()) +
          (col.pills.length - 1) * pillGap;

      // Bottom-anchor: cluster sits 8px above the canvas floor
      double currentY = size.height - totalH - 8;

      for (final h in col.pills) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, currentY, colWidth, h.toDouble()),
            Radius.circular(colWidth / 2),
          ),
          paint,
        );
        currentY += h + pillGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PillSoundwavePainter oldDelegate) =>
      oldDelegate.accentColor != accentColor ||
      oldDelegate.animProgress != animProgress;
}

class _ColumnData {
  final bool isAccent;
  final List<int> pills;
  _ColumnData({required this.isAccent, required this.pills});
}
