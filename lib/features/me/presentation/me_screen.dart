import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../journal/presentation/journal_providers.dart';
import '../../profile/presentation/profile_settings_screen.dart';
import '../../profile/application/theme_service.dart';
import '../../../core/utils/pulse_mapper.dart';
import 'widgets/soul_sphere_widget.dart';
import 'widgets/growth_track_card.dart';
import 'widgets/memory_nodes_overlay.dart';
import 'profile_ecosystem_provider.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);
    final themesAsync = ref.watch(spiritualThemesProvider);
    final sphereStateAsync = ref.watch(soulSphereStateProvider);
    final summaryAsync = ref.watch(journeySummaryProvider);
    final answeredPrayersAsync = ref.watch(answeredPrayerCountProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (entries) {
          final pulseValue = _calculateAveragePulse(entries);
          final streak = _calculateStreak(entries);
          
          return Stack(
            children: [
              // Scrollable Content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. The 3D Ecosystem Section (Scrolls with the rest)
                  SliverToBoxAdapter(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 3D Scene
                        sphereStateAsync.when(
                          data: (state) => SoulSphereWidget(
                            pulseValue: pulseValue,
                            stateId: state,
                          ),
                          loading: () => const SizedBox(height: 380),
                          error: (_, __) => SoulSphereWidget(pulseValue: pulseValue),
                        ),
                        
                        // Memory Nodes Overlay
                        MemoryNodesOverlay(entries: entries),
                        
                        // Narrative Ribbon (Positioned relative to the 3D block)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: _buildNarrativeRibbon(summaryAsync),
                        ),
                      ],
                    ),
                  ),
                  
                  // 2. Profile Header
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    sliver: SliverToBoxAdapter(
                      child: _buildProfileHeader(context, streak),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Section: Growth Tracks
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _buildSectionHeader('Spiritual Growth'),
                    ),
                  ),
                  
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: themesAsync.when(
                      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                      error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
                      data: (themes) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final theme = themes[index];
                            return GrowthTrackCard(
                              theme: theme.name,
                              progress: (theme.frequency / 5).clamp(0.1, 1.0),
                              color: _getThemeColor(index),
                              status: _getThemeStatus(theme.frequency),
                            );
                          },
                          childCount: themes.length,
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Section: Legacy Altar
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _buildLegacyAltar(answeredPrayersAsync),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                  
                  // App Version
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          "ScriptureLens AI v1.5.0 • ECOSYSTEM",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Colors.white12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Settings Button (Fixed top right)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 20,
                child: IconButton(
                  icon: const Icon(LucideIcons.settings, color: Colors.white70),
                  onPressed: () => _navigateToSettings(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, int streak) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.cyanAccent.withValues(alpha: 0.5), Colors.transparent],
            ),
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFF1A1A1A),
            child: const Icon(LucideIcons.user, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Friend",
          style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.flame, size: 14, color: Colors.orangeAccent),
            const SizedBox(width: 4),
            Text(
              "$streak Day Streak",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrativeRibbon(AsyncValue<String> summaryAsync) {
    return summaryAsync.when(
      data: (text) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildLegacyAltar(AsyncValue<int> countAsync) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.scroll, color: Colors.amberAccent, size: 32),
          const SizedBox(height: 16),
          Text(
            'LEGACY ALTAR',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: Colors.amberAccent,
            ),
          ),
          const SizedBox(height: 8),
          countAsync.when(
            data: (count) => Column(
              children: [
                Text(
                  '$count',
                  style: GoogleFonts.lora(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Answered Prayers & Praises',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('---', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Colors.white38,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: Colors.white10)),
      ],
    );
  }

  double _calculateAveragePulse(List<dynamic> entries) {
    if (entries.isEmpty) return 2.0;
    final last7 = entries.take(7);
    final total = last7.map((e) => PulseMapper.getPulseValue(e.emotionTag)).reduce((a, b) => a + b);
    return total / last7.length;
  }

  int _calculateStreak(List<dynamic> entries) {
    if (entries.isEmpty) return 0;
    final sorted = List.from(entries)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    int streak = 0;
    DateTime? lastDate;
    for (final entry in sorted) {
      final entryDate = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      if (lastDate == null) {
        final diff = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).difference(entryDate).inDays;
        if (diff > 1) return 0;
        streak = 1;
        lastDate = entryDate;
      } else {
        final diff = lastDate.difference(entryDate).inDays;
        if (diff == 1) {
          streak++;
          lastDate = entryDate;
        } else if (diff > 1) break;
      }
    }
    return streak;
  }

  Color _getThemeColor(int index) {
    const colors = [Colors.cyanAccent, Colors.purpleAccent, Colors.orangeAccent, Colors.pinkAccent, Colors.greenAccent];
    return colors[index % colors.length];
  }

  String _getThemeStatus(int freq) {
    if (freq >= 3) return 'Blooming';
    if (freq >= 2) return 'Rooting';
    return 'Pruning';
  }

  void _navigateToSettings(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()));
  }
}

