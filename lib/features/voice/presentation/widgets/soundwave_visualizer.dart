import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SoundwaveVisualizer extends StatefulWidget {
  final double height;

  const SoundwaveVisualizer({super.key, this.height = 120});

  @override
  State<SoundwaveVisualizer> createState() => _SoundwaveVisualizerState();
}

class _SoundwaveVisualizerState extends State<SoundwaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _SoundwavePainter(progress: _controller.value),
        );
      },
    );
  }
}

class _SoundwavePainter extends CustomPainter {
  final double progress;

  _SoundwavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final width = size.width;

    // Define 3 wave layers
    final waveConfigs = [
      _WaveConfig(
        color: const Color(0x33FF5714),
        amplitude: 28,
        frequency: 0.02,
        speed: 1.0,
        strokeWidth: 2.0,
      ),
      _WaveConfig(
        color: const Color(0x73FF7832),
        amplitude: 20,
        frequency: 0.03,
        speed: 1.4,
        strokeWidth: 2.5,
      ),
      _WaveConfig(
        color: AppColors.primaryOrange,
        amplitude: 15,
        frequency: 0.04,
        speed: 2.0,
        strokeWidth: 3.5,
      ),
    ];

    for (final config in waveConfigs) {
      final path = Path();
      path.moveTo(0, centerY);

      final paint = Paint()
        ..color = config.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = config.strokeWidth
        ..strokeCap = StrokeCap.round;

      for (double x = 0; x <= width; x += 2) {
        // Bell-curve damping towards edges
        final distFromCenter = ((x - width / 2).abs()) / (width / 2);
        final envelope = math.max(0.0, 1.0 - math.pow(distFromCenter, 2));

        final angle = (x * config.frequency) + (progress * 2 * math.pi * config.speed);
        final y = centerY + math.sin(angle) * config.amplitude * envelope;

        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SoundwavePainter oldDelegate) => true;
}

class _WaveConfig {
  final Color color;
  final double amplitude;
  final double frequency;
  final double speed;
  final double strokeWidth;

  _WaveConfig({
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.speed,
    required this.strokeWidth,
  });
}

