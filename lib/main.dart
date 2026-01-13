import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'features/app_shell/sacred_sanctuary_shell.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/email_verification_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/bible_preloader_service.dart';
import 'ui/theme/liquid_glass_theme.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FlutterGemma for on-device Qwen AI (non-blocking, graceful degradation)
  try {
    await FlutterGemma.initialize();
    print('✅ Qwen model initialized successfully');
  } catch (e) {
    print('⚠️ Failed to initialize Qwen model: $e');
    print('   App will use cloud AI only');
    // Continue without on-device AI - app will fall back to cloud APIs
  }
  
  // We need a ProviderContainer to read the provider before the app starts
  final container = ProviderContainer();
  
  try {
    // Initialize Supabase
    await container.read(apiServiceProvider.notifier).initializeSupabase();
    
    // Preload bundled Bibles on first launch (runs on background isolate)
    container.read(biblePreloaderServiceProvider).preloadBundledBibles();
  } catch (e) {
    print('Failed to initialize: $e');
    // Continue anyway, mock data might work
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _appLinks = AppLinks();
  final _navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }
  
  void _initDeepLinks() {
    // Listen for deep links
    _appLinks.uriLinkStream.listen((uri) async {
      print('📱 Deep link received: $uri');
      
      // Give Supabase a moment to process the auth callback
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check auth state and navigate accordingly
      final authService = AuthService();
      
      if (authService.isAuthenticated && authService.isEmailConfirmed) {
        // Navigate to Bible reader
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const SacredSanctuaryShell()),
        );
      } else if (mounted) {
        // Just refresh if still not confirmed
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'ScriptureLens AI',
      debugShowCheckedModeBanner: false,
      theme: LiquidGlassTheme.theme,
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    final authService = AuthService();
    
    // Not authenticated - show login
    if (!authService.isAuthenticated) {
      return const LoginScreen();
    }
    
    // Authenticated but email not confirmed - show verification screen
    if (!authService.isEmailConfirmed) {
      return EmailVerificationScreen(
        email: authService.userEmail ?? '',
      );
    }
    
    // Fully authenticated and confirmed - show app
    return const SacredSanctuaryShell();
  }
}
