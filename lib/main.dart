import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/presentation/screens/onboarding_welcome_screen.dart';
import 'navigation/main_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlexaApp());
}

class AlexaApp extends StatefulWidget {
  const AlexaApp({super.key});

  @override
  State<AlexaApp> createState() => _AlexaAppState();
}

class _AlexaAppState extends State<AlexaApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onThemeChanged);
    _applySystemUi(ThemeController.instance.isDarkMode);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    // Only update system UI chrome; do NOT rebuild MaterialApp
    _applySystemUi(ThemeController.instance.isDarkMode);
  }

  void _applySystemUi(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? const Color(0xFF0B0B0E) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp is built ONCE — theme transition is handled inside each screen
    // via AnimatedBuilder + AnimationController for buttery-smooth 60fps animation.
    return MaterialApp(
      title: 'Alexa AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;

        // Normal base standard smartphone width adalah ~392 dp.
        // Jika user mengubah DPI di Developer Options (misal DPI 500 -> logical width ~480-520 dp),
        // scaleFactor mengimbangi agar teks dan elemen UI tetap tampil nyaman dan terbaca seperti di 392 dp normal.
        double scaleFactor = 1.0;
        if (screenWidth > 392.0 && screenWidth < 600.0) {
          scaleFactor = (screenWidth / 392.0).clamp(1.0, 1.30);
        }

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(scaleFactor),
          ),
          child: child!,
        );
      },
      home: Builder(
        builder: (context) => OnboardingWelcomeScreen(
          assetMediaPath: 'assets/onboarding_gif.gif',
          onGetStarted: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavScreen()),
            );
          },
          onLogin: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavScreen()),
            );
          },
        ),
      ),
    );
  }
}
