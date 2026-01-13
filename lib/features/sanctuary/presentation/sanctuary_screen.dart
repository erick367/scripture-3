import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../home/presentation/home_screen.dart';
import '../../me/presentation/me_screen.dart';
import '../../journal/presentation/journal_providers.dart';
import '../../../core/utils/pulse_mapper.dart';
import '../../me/presentation/widgets/soul_sphere_widget.dart';
import '../../me/presentation/profile_ecosystem_provider.dart';

/// The Sanctuary - Tab 0
/// 
/// Unified hub merging Home Dashboard and Me/Profile screens.
/// Features:
/// - Soul Sphere (3D kinetic visualization)
/// - Aura Narrative (AI-generated summary)
/// - Daily insights, AI follow-ups, stuck detection
/// - Legacy Altar, growth tracks, profile
class SanctuaryScreen extends ConsumerStatefulWidget {
  const SanctuaryScreen({super.key});

  @override
  ConsumerState<SanctuaryScreen> createState() => _SanctuaryScreenState();
}

class _SanctuaryScreenState extends ConsumerState<SanctuaryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Soul Sphere Header
          _buildSoulSphereHeader(),
          
          // Tab Bar (Pulse / Legacy)
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabController: _tabController,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            // Tab 1: Pulse (Home Dashboard content)
            HomeScreen(),
            // Tab 2: Legacy (Me/Profile content)
            MeScreen(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSoulSphereHeader() {
    final entriesAsync = ref.watch(journalEntriesProvider);
    final sphereStateAsync = ref.watch(soulSphereStateProvider);
    final summaryAsync = ref.watch(journeySummaryProvider);
    
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF12121E),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soul Sphere
            entriesAsync.when(
              data: (entries) {
                final pulseValue = _calculateAveragePulse(entries);
                return sphereStateAsync.when(
                  data: (state) => SoulSphereWidget(
                    pulseValue: pulseValue,
                    stateId: state,
                  ),
                  loading: () => const SizedBox(height: 200),
                  error: (_, __) => SoulSphereWidget(pulseValue: pulseValue),
                );
              },
              loading: () => const CircularProgressIndicator(
                color: Color(0xFF00F2FF),
              ),
              error: (_, __) => const Icon(
                LucideIcons.alertCircle,
                color: Colors.red,
                size: 48,
              ),
            ),
            
            // Aura Narrative Ribbon (bottom)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildAuraNarrative(summaryAsync),
            ),
            
            // Title at top
            Positioned(
              top: 16,
              child: Text(
                'THE SANCTUARY',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAuraNarrative(AsyncValue<String> summaryAsync) {
    return summaryAsync.when(
      data: (text) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.sparkles,
                  size: 16,
                  color: Color(0xFF00F2FF),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.lora(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
  
  double _calculateAveragePulse(List<dynamic> entries) {
    if (entries.isEmpty) return 2.5;
    final last7 = entries.take(7);
    final total = last7
        .map((e) => PulseMapper.getPulseValue(e.emotionTag))
        .reduce((a, b) => a + b);
    return total / last7.length;
  }
}

/// Persistent tab bar delegate for sticky tabs
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  
  _TabBarDelegate({required this.tabController});
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF12121E),
      child: TabBar(
        controller: tabController,
        indicatorColor: const Color(0xFF00F2FF),
        indicatorWeight: 2,
        labelColor: const Color(0xFF00F2FF),
        unselectedLabelColor: Colors.white54,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        onTap: (_) => HapticFeedback.selectionClick(),
        tabs: const [
          Tab(text: 'PULSE'),
          Tab(text: 'LEGACY'),
        ],
      ),
    );
  }
  
  @override
  double get maxExtent => 48;
  
  @override
  double get minExtent => 48;
  
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
