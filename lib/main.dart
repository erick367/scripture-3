import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ScriptureLensApp(),
    ),
  );
}

/// Scripture Lens 2.0 - Main App
class ScriptureLensApp extends StatelessWidget {
  const ScriptureLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scripture Lens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.isDarkMode() ? ThemeMode.dark : ThemeMode.light,
      home: const AppShell(),
    );
  }
}
