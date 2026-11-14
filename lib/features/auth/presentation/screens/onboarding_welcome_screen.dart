import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/people_icon.dart';

class OnboardingWelcomeScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? assetMediaPath;
  final VoidCallback? onGetStarted;
  final VoidCallback? onLogin;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const OnboardingWelcomeScreen({
    super.key,
    this.title = 'Welcome to Alexastant',
    this.subtitle = 'Starting today, organizing your schedule & tasks\ntakes less than 30 seconds a day.',
    this.assetMediaPath,
    this.onGetStarted,
    this.onLogin,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  State<OnboardingWelcomeScreen> createState() => _OnboardingWelcomeScreenState();
}

class _OnboardingWelcomeScreenState extends State<OnboardingWelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;

  late final AnimationController _buttonPressController;
  late final Animation<double> _buttonScaleAnim;

  @override
  void initState() {
    super.initState();

    // ── Entrance Animation (Fade & Slide Up matching React Native timing) ───
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // Fade: 0.0 -> 1.0 between 200ms and 1100ms (~900ms duration)
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.18, 1.0, curve: Curves.easeOut),
    );

    // Slide: 30px -> 0px between 200ms and 900ms (~700ms duration)
    _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.18, 0.82, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();

    // ── Button Spring Scale Animation ─────────────────────────────────────
    _buttonPressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _buttonPressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _buttonPressController.dispose();
    super.dispose();
  }

  void _handlePressIn() {
    _buttonPressController.forward();
  }

  void _handlePressOut() {
    _buttonPressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomInset = mediaQuery.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── 1. Top Visual / Media Area (height ~ 45% screen) ───────────
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              height: screenHeight * 0.48,
              child: _buildHeroMedia(),
            ),

            // ── 2. Bottom Content Sheet ────────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  28,
                  12,
                  28,
                  bottomInset > 0 ? bottomInset + 12 : 28,
                ),
                child: AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 5-Figure Icon
                      const Padding(
                        padding: EdgeInsets.only(bottom: 28),
                        child: Center(
                          child: PeopleIcon(size: 72, color: Colors.white),
                        ),
                      ),

                      // Title
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.65),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // CTA Button: "Get Started" (with spring click feedback)
                      AnimatedBuilder(
                        animation: _buttonScaleAnim,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScaleAnim.value,
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTapDown: (_) => _handlePressIn(),
                          onTapUp: (_) {
                            _handlePressOut();
                            widget.onGetStarted?.call();
                          },
                          onTapCancel: () => _handlePressOut(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Login Link
                      GestureDetector(
                        onTap: widget.onLogin,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.70),
                              ),
                              children: const [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Log in',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Legal Footer
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.35),
                            height: 1.55,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By tapping Get Started, I agree with the ',
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: widget.onTermsTap,
                                child: Text(
                                  'Terms of Service',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.55),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withOpacity(0.55),
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: widget.onPrivacyTap,
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.55),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withOpacity(0.55),
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the top visual hero (GIF / Image / Fallback Ambient Animation)
  Widget _buildHeroMedia() {
    if (widget.assetMediaPath != null && widget.assetMediaPath!.isNotEmpty) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Image.asset(
          widget.assetMediaPath!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _buildFallbackHero(),
        ),
      );
    }
    return _buildFallbackHero();
  }

  Widget _buildFallbackHero() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        gradient: RadialGradient(
          center: Alignment(0, -0.2),
          radius: 0.9,
          colors: [
            Color(0xFF1E2433),
            Color(0xFF0F121A),
            Colors.black,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient soft glow orb
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withOpacity(0.12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF818CF8).withOpacity(0.20),
                  blurRadius: 90,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          // Subtle grid or card silhouette
          Container(
            width: 140,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 40,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

