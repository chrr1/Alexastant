import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
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
      home: const MainNavScreen(),
    );
  }
}
