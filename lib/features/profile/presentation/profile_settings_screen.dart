import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;
import '../../settings/services/key_vault_service.dart';
import '../../journal/data/sync_service.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _isSyncing = false;
  bool _isBackingUp = false;
  String _syncStatus = 'Ready';
  String _vaultStatus = 'Not backed up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Security'),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: LucideIcons.key,
              iconColor: Colors.amber,
              title: 'Key Vault',
              subtitle: _vaultStatus,
              trailing: _isBackingUp
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                    )
                  : ElevatedButton(
                      onPressed: _backupKey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.withValues(alpha: 0.2),
                        foregroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Backup', style: GoogleFonts.inter(fontSize: 12)),
                    ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: LucideIcons.cloud,
              iconColor: Colors.blueAccent,
              title: 'Sync Status',
              subtitle: _syncStatus,
              trailing: _isSyncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
                    )
                  : ElevatedButton(
                      onPressed: _forceSync,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                        foregroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Sync Now', style: GoogleFonts.inter(fontSize: 12)),
                    ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('AI Memory'),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: LucideIcons.brain,
              iconColor: Colors.purpleAccent,
              title: 'AI Memory',
              subtitle: 'Allow AI to learn from your journal',
              trailing: Switch(
                value: true, // TODO: Connect to global setting
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  // TODO: Update global AI memory setting
                },
                activeTrackColor: Colors.purpleAccent,
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('About'),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: LucideIcons.info,
              iconColor: Colors.grey,
              title: 'Version',
              subtitle: '1.0.0 (Phase 14)',
              trailing: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white54,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _backupKey() async {
    HapticFeedback.lightImpact();
    setState(() => _isBackingUp = true);
    
    try {
      final vault = ref.read(keyVaultServiceProvider);
      await vault.backupKey();
      setState(() => _vaultStatus = 'Backed up just now');
    } catch (e) {
      setState(() => _vaultStatus = 'Backup failed');
    } finally {
      setState(() => _isBackingUp = false);
    }
  }

  Future<void> _forceSync() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing...';
    });
    
    try {
      final syncService = ref.read(syncServiceProvider);
      final count = await syncService.processQueue();
      setState(() => _syncStatus = count > 0 ? 'Synced $count items' : 'All synced');
    } catch (e) {
      setState(() => _syncStatus = 'Sync failed');
    } finally {
      setState(() => _isSyncing = false);
    }
  }
}
