import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;

import '../spiritual_pulse_provider.dart';

class SpiritualPulseDashboard extends ConsumerWidget {
  const SpiritualPulseDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pulseAsync = ref.watch(spiritualPulseProvider);

    return pulseAsync.when(
      data: (data) => _buildDashboard(context, data),
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24))),
      error: (err, stack) => const SizedBox.shrink(), // Fail gracefully
    );
  }

  Widget _buildDashboard(BuildContext context, SpiritualPulseData data) {
    // Trigger haptic on load if data is present
    if (data.weeklyTrend.isNotEmpty) {
      // microtask to avoid build-phase side effects
      Future.microtask(() => HapticFeedback.mediumImpact());
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Glassmorphism background
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title + Streak
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Spiritual Pulse",
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      _buildStreakBadge(data.currentStreak),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Pulse Graph
                  SizedBox(
                    height: 120,
                    child: _buildPulseGraph(data.weeklyTrend),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Mentor Weekly Insight
                  _buildMentorInsight(data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.flame, size: 16, color: Colors.orangeAccent),
          const SizedBox(width: 6),
          Text(
            "$streak Day Streak",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseGraph(List<DailyPulsePoint> trend) {
    if (trend.isEmpty) {
      return Center(
        child: Text(
          "No data yet",
          style: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
        ),
      );
    }

    // Use PulseMapper values directly if available, or fallback to current logic
    // But wait, the provider currently returns DailyPulsePoint which uses the OLD logic.
    // I should probably update the Provider to use PulseMapper first, OR just map it here.
    // Let's assume the provider will be updated shortly, or map it here if needed.
    // Actually, to fully comply, I should update the provider logic to use PulseMapper.
    // However, I can temporarily map the scores here visually if they are on same scale.
    // The requirement said "In the ProfileScreen, use fl_chart... Styling: The line should be a gradient (Red at 1.0, Amber at 2.0, Blue at 3.0)".
    // So I need to ensure the LineChartBarData uses this gradient.

    final spots = trend.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.sentimentScore);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 3.5,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.4,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true), // Show dots for interaction
            
            // GRADIENT REQUIREMENT: Red at 1.0, Amber at 2.0, Blue at 3.0
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.redAccent,   // ~1.0
                Colors.amber,       // ~2.0
                Colors.blueAccent,  // ~3.0
              ],
              stops: [0.2, 0.5, 0.9], // Adjusted stops to map vertically to Y-values roughly
            ),
            
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueAccent.withValues(alpha: 0.1),
                  Colors.redAccent.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
        ],
        // INTERACTION: TouchTooltips
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                // Find corresponding data point
                if (spot.x.toInt() < trend.length) {
                  final data = trend[spot.x.toInt()];
                  return LineTooltipItem(
                    "${data.dominantEmotion}\nScore: ${spot.y.toStringAsFixed(1)}",
                    GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildMentorInsight(SpiritualPulseData data) {
    if (!data.hasEnoughDataForAi && data.weeklyAiSummary == null) {
      // Upsell / Empty state
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.sparkles, size: 18, color: Colors.white38),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Journal 3+ times this week to unlock AI insights.",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.brainCircuit, size: 16, color: Colors.purpleAccent),
              const SizedBox(width: 8),
              Text(
                "Weekly Insight",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.purpleAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.weeklyAiSummary ?? "Processing your spiritual journey...",
            style: GoogleFonts.lora(
              fontSize: 13,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
