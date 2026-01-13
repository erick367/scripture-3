import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../services/auth_service.dart';
import '../../../domain/services/consent_manager.dart';
import '../../../services/consent_manager_impl.dart';
import '../../../ui/theme/liquid_glass_theme.dart';

/// Profile Settings Screen
/// 
/// Handles:
/// - Privacy controls and consent management
/// - API key configuration
/// - Data sync settings
/// - Account management
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _cloudAiEnabled = false;
  bool _journalSyncEnabled = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final consent = ref.read(consentManagerProvider);
    final cloudEnabled = await consent.isCloudAIEnabled();
    final journalConsent = await consent.hasConsent(ConsentFeature.journalAIAccess);
    
    if (mounted) {
      setState(() {
        _cloudAiEnabled = cloudEnabled;
        _journalSyncEnabled = journalConsent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiquidGlassTheme.deepSpaceBlack,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          
          // Privacy Section
          _buildSectionHeader('PRIVACY'),
          const SizedBox(height: 12),
          
          _buildSettingCard(
            icon: LucideIcons.cloud,
            title: 'Cloud AI Features',
            subtitle: 'Enable Claude for deep insights',
            trailing: Switch.adaptive(
              value: _cloudAiEnabled,
              onChanged: (value) async {
                HapticFeedback.lightImpact();
                final consent = ref.read(consentManagerProvider);
                await consent.setCloudAIEnabled(value);
                setState(() => _cloudAiEnabled = value);
              },
              activeColor: LiquidGlassTheme.radiantCyan,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildSettingCard(
            icon: LucideIcons.lock,
            title: 'Journal AI Access',
            subtitle: 'Allow AI to read reflections for personalized insights',
            trailing: Switch.adaptive(
              value: _journalSyncEnabled,
              onChanged: (value) async {
                HapticFeedback.lightImpact();
                final consent = ref.read(consentManagerProvider);
                await consent.recordConsent(
                  feature: ConsentFeature.journalAIAccess,
                  granted: value,
                );
                setState(() => _journalSyncEnabled = value);
              },
              activeColor: LiquidGlassTheme.radiantCyan,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'When enabled, journal entries marked with "AI Access" will be processed for personalized insights. All data is encrypted and PII is automatically scrubbed.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white38,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Data Section
          _buildSectionHeader('DATA'),
          const SizedBox(height: 12),
          
          _buildSettingCard(
            icon: LucideIcons.database,
            title: 'Local Storage',
            subtitle: 'Bible and journal data encrypted on device',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LiquidGlassTheme.livingMoss.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ENCRYPTED',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: LiquidGlassTheme.livingMoss,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildSettingCard(
            icon: LucideIcons.history,
            title: 'Privacy Audit Log',
            subtitle: 'View consent history and data decisions',
            onTap: () => _showAuditLog(context),
            trailing: const Icon(
              LucideIcons.chevronRight,
              color: Colors.white38,
              size: 20,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Account Section
          _buildSectionHeader('ACCOUNT'),
          const SizedBox(height: 12),
          
          _buildSettingCard(
            icon: LucideIcons.user,
            title: 'Profile',
            subtitle: AuthService().userEmail ?? 'Not signed in',
            trailing: const Icon(
              LucideIcons.chevronRight,
              color: Colors.white38,
              size: 20,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildSettingCard(
            icon: LucideIcons.logOut,
            title: 'Sign Out',
            subtitle: 'Log out of your account',
            onTap: () => _confirmSignOut(context),
            isDestructive: true,
          ),
          
          const SizedBox(height: 48),
          
          // App Info
          Center(
            child: Column(
              children: [
                Text(
                  'ScriptureLens AI',
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 100), // Bottom padding for nav bar
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: LiquidGlassTheme.headerStyle(),
      ),
    );
  }
  
  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap != null ? () {
        HapticFeedback.lightImpact();
        onTap();
      } : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: LiquidGlassTheme.glassCardSubtle(),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDestructive ? LiquidGlassTheme.errorRed : LiquidGlassTheme.radiantCyan)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? LiquidGlassTheme.errorRed : LiquidGlassTheme.radiantCyan,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? LiquidGlassTheme.errorRed : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
  
  Future<void> _showAuditLog(BuildContext context) async {
    final consent = ref.read(consentManagerProvider);
    final events = await consent.getAuditLog(limit: 50);
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: LiquidGlassTheme.indigoCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PRIVACY AUDIT LOG',
              style: LiquidGlassTheme.headerStyle(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: events.isEmpty
                  ? Center(
                      child: Text(
                        'No consent events recorded yet.',
                        style: GoogleFonts.inter(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                event.granted ? LucideIcons.checkCircle : LucideIcons.xCircle,
                                size: 16,
                                color: event.granted ? LiquidGlassTheme.livingMoss : LiquidGlassTheme.errorRed,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.feature.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${event.granted ? "Granted" : "Denied"} • ${_formatDate(event.timestamp)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.month}/${date.day}/${date.year}';
  }
  
  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: LiquidGlassTheme.indigoCharcoal,
        title: Text(
          'Sign Out?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        content: Text(
          'You will need to sign in again to access your data.',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: LiquidGlassTheme.errorRed),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      await AuthService().signOut();
      // Navigate to login screen would happen via auth state listener
    }
  }
}
