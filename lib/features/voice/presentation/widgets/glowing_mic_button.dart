import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class GlowingMicButton extends StatefulWidget {
  final VoidCallback? onTap;

  const GlowingMicButton({super.key, this.onTap});

  @override
  State<GlowingMicButton> createState() => _GlowingMicButtonState();
}

class _GlowingMicButtonState extends State<GlowingMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.35).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 88,
        height: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Pulsating Glow Ring
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryOrange.withOpacity(
                        _opacityAnimation.value,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Inner Center Orange Gradient Button
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.orangeGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrangeGlow,
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

