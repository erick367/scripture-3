import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print('Email sign-in successful: ${_supabase.auth.currentUser?.id}');
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: null, // Disable email confirmation redirect
    );
    
    // Check if user is confirmed
    if (response.user != null && response.session != null) {
      print('Email sign-up successful: ${response.user!.id}');
    } else {
      print('Sign-up requires email confirmation. Check your inbox.');
      throw Exception('Please check your email to confirm your account.');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Resend confirmation email
  Future<void> resendConfirmationEmail(String email) async {
    await _supabase.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _supabase.auth.currentSession != null;

  /// Check if user email is confirmed
  bool get isEmailConfirmed {
    final user = _supabase.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  /// Get current user ID
  String? get userId => _supabase.auth.currentUser?.id;

  /// Get current user email
  String? get userEmail => _supabase.auth.currentUser?.email;
}
