import 'package:flutter/material.dart';

class SignatureBentoCards extends StatelessWidget {
  final Color accentColor;
  final double animProgress;
  final String focusSessionTime;
  final String targetProgressText;

  const SignatureBentoCards({
    super.key,
    required this.accentColor,
    required this.animProgress,
    this.focusSessionTime = '3h 45m',
    this.targetProgressText = '8',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CARD 1: Radiant Rose Coral to Lilac Orchid Card (Skincare App Style)
        Expanded(
          child: Container(
            height: 175,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    accentColor,
                    const Color(0xFFF77678), // Coral Rose
                    animProgress,
                  )!,
                  Color.lerp(
                    accentColor,
                    const Color(0xFFB495F5), // Lilac Lavender Orchid
                    animProgress,
                  )!,
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(
                    const Color(0xFFFF5714).withOpacity(0.35),
                    const Color(0xFFF77678).withOpacity(0.35),
                    animProgress,
                  )!,
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sesi Fokus',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.1,
                  ),
                ),
                // Smooth Curved Line Chart (Bezier)
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SmoothCurvePainter(),
                  ),
                ),
                // Metric bottom value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      focusSessionTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'aktif',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // CARD 2: Solid High-Contrast Clean Slate / White Card
        Expanded(
          child: Container(
            height: 175,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF1B1B22),
                    Colors.white.withOpacity(0.95),
                    animProgress,
                  )!,
                  Color.lerp(
                    const Color(0xFF1B1B22),
                    Colors.white.withOpacity(0.80),
                    animProgress,
                  )!,
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Color.lerp(
                  Colors.white.withOpacity(0.06),
                  Colors.white.withOpacity(0.80),
                  animProgress,
                )!,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(animProgress > 0.5 ? 0.07 : 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tugas & Kuliah',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color.lerp(
                      Colors.white70,
                      const Color(0xFF4A5568),
                      animProgress,
                    )!,
                    letterSpacing: -0.1,
                  ),
                ),
                // Mini Histogram Bars with tight gap
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _MiniHistogramPainter(
                      accentColor: accentColor,
                      animProgress: animProgress,
                    ),
                  ),
                ),
                // Metric bottom value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      targetProgressText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.lerp(
                          Colors.white,
                          const Color(0xFF181C24),
                          animProgress,
                        )!,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ 11 target',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color.lerp(
                          Colors.white60,
                          const Color(0xFF718096),
                          animProgress,
                        )!,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints the smooth bezier curve with an end dot (Card 1)
class _SmoothCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = Colors.white;

    final path = Path();
    path.moveTo(0, size.height * 0.65);

    // Smooth Bezier wave
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.90,
      size.width * 0.45,
      size.height * 0.20,
      size.width * 0.70,
      size.height * 0.75,
    );
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.95,
      size.width * 0.92,
      size.height * 0.35,
      size.width * 0.96,
      size.height * 0.25,
    );

    canvas.drawPath(path, linePaint);

    // End point dot
    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.25),
      3.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the mini histogram bars inside the dark slate card (Card 2) with smooth interpolation.
class _MiniHistogramPainter extends CustomPainter {
  final Color accentColor;
  final double animProgress;

  _MiniHistogramPainter({
    required this.accentColor,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 8 slots activity histogram with compact gap
    final barData = [
      {'ratio': 0.35, 'isHighlight': false},
      {'ratio': 0.58, 'isHighlight': false},
      {'ratio': 0.45, 'isHighlight': false},
      {'ratio': 0.75, 'isHighlight': false},
      {'ratio': 0.95, 'isHighlight': true}, // Peak / Today
      {'ratio': 0.65, 'isHighlight': false},
      {'ratio': 0.40, 'isHighlight': false},
      {'ratio': 0.55, 'isHighlight': false},
    ];

    // Compact gap between bars so they sit closely together
    const gap = 5.0;
    final barWidth =
        (size.width - ((barData.length - 1) * gap)) / barData.length;

    final normalBarColor = Color.lerp(
      Colors.white.withOpacity(0.18),
      const Color(0xFFCBD5E1), // Crisp slate grey bar in light mode
      animProgress,
    )!;

    for (int i = 0; i < barData.length; i++) {
      final item = barData[i];
      final ratio = item['ratio'] as double;
      final isHighlight = item['isHighlight'] as bool;

      final barH = size.height * ratio;
      final x = i * (barWidth + gap);
      final y = size.height - barH;

      final paint = Paint()
        ..color = isHighlight ? accentColor : normalBarColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barH),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniHistogramPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor ||
      oldDelegate.animProgress != animProgress;
}
