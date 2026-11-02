import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'navigation/main_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0B0B0E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AlexaApp());
}

class AlexaApp extends StatelessWidget {
  const AlexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alexa AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavScreen(),
    );
  }
}
