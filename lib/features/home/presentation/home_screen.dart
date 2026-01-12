import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;

import '../../journal/presentation/spiritual_pulse_provider.dart';
import '../../discover/presentation/widgets/discovery_deep_dive_sheet.dart';
import '../../discover/application/discovery_feed_service.dart';
import '../../../features/bible/presentation/bible_reader_screen.dart'; // For navIndexProvider
import 'home_providers.dart';
import 'home_dashboard_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep dark background
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E1E1E),
                  const Color(0xFF000000),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PulseHeader(),
                  const SizedBox(height: 32),
                  const _StuckDetectorCard(),
                  const SizedBox(height: 24),
                  const _DailyFactCard(),
                  const SizedBox(height: 24),
                  const _DailyPrayerCard(),
                  const SizedBox(height: 24),
                  const _AiFollowUpCard(),
                  const SizedBox(height: 100), // Bottom padding for content
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseHeader extends ConsumerWidget {
  const _PulseHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final pulseAsync = ref.watch(spiritualPulseProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good evening, $userName.',
              style: GoogleFonts.lora(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ready to reflect?',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        
        // Profile / Streak Icon with Success Glow
        pulseAsync.when(
          data: (data) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: data.currentStreak > 0 ? [
                BoxShadow(
                  color: Colors.orangeAccent.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Icon(
                   data.currentStreak > 0 ? LucideIcons.flame : LucideIcons.user,
                   color: data.currentStreak > 0 ? Colors.orangeAccent : Colors.white70,
                   size: 20
                 ),
                 if (data.currentStreak > 0) ...[
                   const SizedBox(width: 4),
                   Text(
                     '${data.currentStreak}',
                     style: GoogleFonts.inter(
                       color: Colors.orangeAccent,
                       fontWeight: FontWeight.bold,
                       fontSize: 12
                     ),
                   )
                 ]
              ],
            ),
          ),
          loading: () => const CircleAvatar(
            backgroundColor: Colors.white10, 
            radius: 22, 
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          ),
          error: (_, __) => const CircleAvatar(backgroundColor: Colors.white10, radius: 22, child: Icon(LucideIcons.user, color: Colors.white70)),
        ),
      ],
    );
  }
}

class _DailyFactCard extends ConsumerWidget {
  const _DailyFactCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factAsync = ref.watch(dailyFactProvider);
    final discoveries = ref.watch(liveArchaeologyProvider);

    return factAsync.when(
      data: (fact) => GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          // Navigate to Discovery Deep Dive
          discoveries.whenData((items) {
            if (items.isNotEmpty) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DiscoveryDeepDiveSheet(discovery: items.first),
              );
            }
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Glassmorphism
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.sparkles, color: Colors.amberAccent, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'DAILY INSIGHT',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      fact,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tap to explore',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white38,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(LucideIcons.arrowRight, size: 12, color: Colors.white38),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _AiFollowUpCard extends ConsumerWidget {
  const _AiFollowUpCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiPromptAsync = ref.watch(homeDashboardControllerProvider);
    final userName = ref.watch(userNameProvider);

    return aiPromptAsync.when(
      data: (prompt) {
        if (prompt == null) {
          // Empty state - Encouragement to start
          return _buildCard(
            context,
            ref, // Pass ref
            icon: LucideIcons.bookOpen,
            title: "Start Your Journey",
            content: "Your journal is waiting. Start documenting your walk to unlock AI insights.",
            actionLabel: "Write First Entry",
            isHighlight: false,
          );
        }
        
        return _buildCard(
          context,
          ref, // Pass ref
          icon: LucideIcons.messageSquare,
          title: "AI Check-in",
          content: "Hi $userName, $prompt", // Prompt already formatted by controller
          actionLabel: "Reply to Mentor",
          isHighlight: true,
        );
      },
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref, // Add ref parameter
    {
    required IconData icon,
    required String title,
    required String content,
    required String actionLabel,
    required bool isHighlight,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight 
            ? const Color(0xFF6366F1).withValues(alpha: 0.1) 
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight 
              ? const Color(0xFF6366F1).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isHighlight 
                      ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: isHighlight ? const Color(0xFF818CF8) : Colors.white70),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
               HapticFeedback.lightImpact();
               // Navigate to Mentor tab (index 4)
               ref.read(navIndexProvider.notifier).state = 4;
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isHighlight ? const Color(0xFF818CF8) : Colors.amberAccent,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  LucideIcons.arrowRight, 
                  size: 14, 
                  color: isHighlight ? const Color(0xFF818CF8) : Colors.amberAccent
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StuckDetectorCard extends ConsumerWidget {
  const _StuckDetectorCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stuckStatusAsync = ref.watch(stuckStatusProvider);

    return stuckStatusAsync.when(
      data: (status) {
        // Only show if user is stuck
        if (status == null) return const SizedBox.shrink();

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          LucideIcons.compass,
                          size: 18,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'DISCOVERY DIAGNOSTIC',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: const Color(0xFFFBBF24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'It looks like you\'ve been on ${status.lastBook} ${status.lastChapter} for a while. Need a new perspective?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Navigate to Discover tab (index 1)
                      ref.read(navIndexProvider.notifier).state = 1;
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Context Breakthrough',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFBBF24),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          LucideIcons.arrowRight,
                          size: 14,
                          color: Color(0xFFFBBF24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _DailyPrayerCard extends ConsumerWidget {
  const _DailyPrayerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerAsync = ref.watch(dailyPrayerProvider);

    return prayerAsync.when(
      data: (prayer) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25), // Deeper blur for sacred space
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.15),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.3), // Candlelight gold border
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.15), // Candlelight gold
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.heart,
                        size: 18,
                        color: Color(0xFFD4AF37), // Candlelight gold
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'DAILY BREATH',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: const Color(0xFFD4AF37), // Candlelight gold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  prayer,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    height: 1.6,
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.95), // Candlelight gold text
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '— Amen',
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.7), // Candlelight gold
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
