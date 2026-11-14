import 'package:flutter/material.dart';

/// PeopleIcon: 5 stylized human silhouettes arranged horizontally
/// with center emphasis (scale & opacity interpolation) matching the React Native design.
class PeopleIcon extends StatelessWidget {
  final double size;
  final Color color;

  const PeopleIcon({
    super.key,
    this.size = 64,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final figureSize = size / 5;
    final headSize = figureSize * 0.55;
    final bodyWidth = figureSize * 0.5;
    final bodyHeight = figureSize * 0.6;

    final figures = [
      _FigureConfig(left: 0, scale: 0.8, opacity: 0.6),
      _FigureConfig(left: figureSize * 0.9, scale: 0.9, opacity: 0.75),
      _FigureConfig(left: figureSize * 2.0, scale: 1.0, opacity: 1.0),
      _FigureConfig(left: figureSize * 3.1, scale: 0.9, opacity: 0.75),
      _FigureConfig(left: figureSize * 4.0, scale: 0.8, opacity: 0.6),
    ];

    return SizedBox(
      width: size + figureSize * 0.5,
      height: size * 0.7,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: figures.map((fig) {
          return Positioned(
            left: fig.left,
            bottom: 0,
            child: Opacity(
              opacity: fig.opacity,
              child: Transform.scale(
                scale: fig.scale,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Head
                    Container(
                      width: headSize,
                      height: headSize,
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Body
                    Container(
                      width: bodyWidth,
                      height: bodyHeight,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(bodyWidth / 2),
                          topRight: Radius.circular(bodyWidth / 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FigureConfig {
  final double left;
  final double scale;
  final double opacity;

  const _FigureConfig({
    required this.left,
    required this.scale,
    required this.opacity,
  });
}

