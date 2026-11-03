import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'navigation/main_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlexaApp());
}

class AlexaApp extends StatelessWidget {
  const AlexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final isDark = ThemeController.instance.isDarkMode;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: isDark ? const Color(0xFF0B0B0E) : Colors.white,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );
        return MaterialApp(
          title: 'Alexa AI Assistant',
          debugShowCheckedModeBanner: false,
          theme: isDark ? AppTheme.darkTheme : ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color(0xFFF0F4F8),
          ),
          home: const MainNavScreen(),
        );
      },
    );
  }
}
