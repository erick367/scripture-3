import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final keyVaultServiceProvider = Provider<KeyVaultService>((ref) {
  return KeyVaultService();
});

class KeyVaultService {
  final _storage = const FlutterSecureStorage();
  final _supabase = Supabase.instance.client;

  static const _storageKey = 'db_encryption_key';

  /// Backs up the local encryption key to Supabase Vault
  /// Should be called after successful login/signup
  Future<void> backupKey() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    // 1. Read Local Key
    final key = await _storage.read(key: _storageKey);
    if (key == null) throw Exception('No local database key found to backup');

    // 2. Upload to Vault (RLS protected)
    // We upsert to ensure only one active key backup per user
    await _supabase.from('user_vault').upsert({
      'user_id': userId,
      'encrypted_db_key': key, // Stored in RLS-protected table
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Restores the encryption key from Supabase Vault
  /// Should be called on new device login if local DB fails to open
  Future<bool> restoreKey() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      // 1. Fetch from Vault
      final data = await _supabase
          .from('user_vault')
          .select('encrypted_db_key')
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) return false; // No backup found

      final key = data['encrypted_db_key'] as String;

      // 2. Write to Local Storage
      await _storage.write(key: _storageKey, value: key);
      return true;
    } catch (e) {
      print('Key restoration failed: $e');
      return false;
    }
  }
}
