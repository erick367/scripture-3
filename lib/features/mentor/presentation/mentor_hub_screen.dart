import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;

import '../application/mentor_providers.dart';
import 'widgets/mentor_design.dart';
import 'widgets/mentor_status_card.dart';
import 'widgets/word_study_sheet.dart';
import 'widgets/journey_card.dart';
import 'mentorship_session_screen.dart';

class MentorHubScreen extends ConsumerWidget {
  const MentorHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger haptic on entry
    Future.microtask(() => HapticFeedback.mediumImpact());
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Heavy Glassmorphic Background
          _buildBackgroundGradient(),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 24),
                  
                  // NEW: Mentor Status Card (Active Focus)
                  const MentorStatusCard(),
                  
                  const SizedBox(height: 32),
                  
                  // AI Quiz CTA
                  _buildQuizCard(context),
                  
                  const SizedBox(height: 32),
                  
                  // Scholar's Notebook (Horizontal Scroll Library)
                  _buildSectionHeader("Scholar's Notebook", Colors.amber),
                  const SizedBox(height: 16),
                  _buildHorizontalScholarChips(ref, context),
                  
                  const SizedBox(height: 32),
                  
                  // Active Journeys (Theme-Grouped)
                  _buildSectionHeader("Your Journeys", Colors.purpleAccent),
                  const SizedBox(height: 16),
                  _buildJourneysList(ref, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundGradient() {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1E1E1E),
                const Color(0xFF000000),
              ],
            ),
          ),
        ),
        // Ambient glow for "floating desk" effect
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  MentorDesign.primaryAccent.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.purpleAccent.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mentor Hub",
                style: GoogleFonts.lora(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Deepen your understanding.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        // Settings/Options button
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(LucideIcons.settings, color: Colors.white38, size: 20),
        ),
      ],
    );
  }
  
  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context) {
    return GlassCard(
      height: 140,
      accentColor: MentorDesign.primaryAccent,
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("AI Quiz coming soon!")),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Prevent overflow
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: MentorDesign.primaryAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "NEW",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Test Your Knowledge",
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    "Quick quiz based on recent readings.",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.graduationCap, color: Colors.white, size: 24),

          ),
        ],
      ),
    );
  }

  /// Horizontal scrolling Scholar's Notebook with 15 biblical terms
  Widget _buildHorizontalScholarChips(WidgetRef ref, BuildContext context) {
    final termsAsync = ref.watch(linguisticTermsProvider);
    
    return termsAsync.when(
      loading: () => SizedBox(
        height: 70,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (terms) {
        if (terms.isEmpty) {
          return Text(
            "Read more to unlock linguistic insights.",
            style: GoogleFonts.inter(color: Colors.white24, fontStyle: FontStyle.italic),
          );
        }
        
        return SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: terms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final term = terms[index];
              final color = MentorDesign.languageColor(term.language);
              
              return GlassChip(
                label: term.term,
                sublabel: term.definition,
                accentColor: color,
                onTap: () {
                  HapticFeedback.lightImpact();
                  WordStudySheet.show(
                    context,
                    term: term.term,
                    language: term.language,
                    basicDefinition: term.definition,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Theme-grouped Journeys (replaces chronological Active Threads)
  Widget _buildJourneysList(WidgetRef ref, BuildContext context) {
    final journeysAsync = ref.watch(journeyGroupsProvider);

    return journeysAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white24),
      ),
      error: (e, _) => Center(
        child: Text(
          "Error loading journeys",
          style: GoogleFonts.inter(color: Colors.red),
        ),
      ),
      data: (journeys) {
        if (journeys.isEmpty) {
          return _buildEmptyJourneysState();
        }

        return Column(
          children: journeys.map((journey) => JourneyCard(
            journey: journey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MentorshipSessionScreen(journey: journey),
                ),
              );
            },
          )).toList(),
        );
      },
    );
  }
  
  Widget _buildEmptyJourneysState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.compass,
                color: Colors.white24,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No journeys yet.",
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start a reflection in the Bible Reader\nto begin your first spiritual journey.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white38,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
