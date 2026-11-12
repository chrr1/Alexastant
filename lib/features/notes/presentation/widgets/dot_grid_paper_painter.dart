import 'package:flutter/material.dart';

/// CustomPainter untuk menggambar dot-grid (titik-titik berjarak teratur)
/// khas buku catatan premium (seperti Rhodia / Leuchtturm 1917).
class DotGridPaperPainter extends CustomPainter {
  final Color dotColor;
  final double spacing;
  final double dotRadius;

  const DotGridPaperPainter({
    this.dotColor = const Color(0xFFCBD5E1),
    this.spacing = 20.0,
    this.dotRadius = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Offset awal agar margin tepi rapi
    const startX = 14.0;
    const startY = 14.0;

    for (double y = startY; y < size.height - startY; y += spacing) {
      for (double x = startX; x < size.width - startX; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotGridPaperPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor ||
        oldDelegate.spacing != spacing ||
        oldDelegate.dotRadius != dotRadius;
  }
}

