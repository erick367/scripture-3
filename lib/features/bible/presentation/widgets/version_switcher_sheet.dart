import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../presentation/state/bible_reader_state.dart';
import '../../../../services/verse_provider_service.dart';

class VersionSwitcherSheet extends ConsumerWidget {
  const VersionSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bibleReaderStateProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Text(
            'Select Version',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildSectionTitle('Offline Ready (Instant)'),
                ...VerseProviderService.bundledVersions.map((v) => 
                  _buildVersionTile(context, ref, v, state.currentVersion, isOffline: true)
                ),
                
                const SizedBox(height: 16),
                _buildSectionTitle('Cloud Library (Requires Internet)'),
                ...VerseProviderService.apiOnlyVersions.map((v) => 
                  _buildVersionTile(context, ref, v, state.currentVersion, isOffline: false)
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white54,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildVersionTile(BuildContext context, WidgetRef ref, String version, String currentVersion, {required bool isOffline}) {
    final isSelected = version == currentVersion;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: () {
        ref.read(bibleReaderStateProvider.notifier).setVersion(version);
        Navigator.pop(context);
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            version.substring(0, 1),
            style: GoogleFonts.lora( // Sergeant style for Bible letters
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      title: Text(
        _getVersionName(version),
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 16,
        ),
      ),
      subtitle: isOffline && version == 'RV1909' ? Text('Spanish', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOffline)
            Icon(LucideIcons.checkCircle, size: 16, color: Colors.green.withValues(alpha: 0.6))
          else
            Icon(LucideIcons.cloud, size: 16, color: Colors.blue.withValues(alpha: 0.6)),
            
          if (isSelected) ...[
            const SizedBox(width: 12),
            const Icon(LucideIcons.check, color: Colors.amber),
          ],
        ],
      ),
    );
  }
  
  String _getVersionName(String code) {
    switch (code) {
      case 'WEB': return 'World English Bible';
      case 'KJV': return 'King James Version';
      case 'BSB': return 'Berean Standard Bible';
      case 'RV1909': return 'Reina Valera 1909';
      case 'NIV': return 'New International Version';
      case 'ESV': return 'English Standard Version';
      case 'GNBUK': return 'Good News Bible';
      default: return code;
    }
  }
}
