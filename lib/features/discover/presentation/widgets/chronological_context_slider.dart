import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../../application/timeline_service.dart';

class ChronologicalContextSlider extends StatefulWidget {
  const ChronologicalContextSlider({super.key});

  @override
  State<ChronologicalContextSlider> createState() => _ChronologicalContextSliderState();
}

class _ChronologicalContextSliderState extends State<ChronologicalContextSlider> {
  final TimelineService _timelineService = TimelineService();
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final eras = _timelineService.getEras();

    return SizedBox(
      height: _expandedIndex != null ? 380 : 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: eras.length,
        itemBuilder: (context, index) {
          final era = eras[index];
          final isExpanded = _expandedIndex == index;
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isExpanded ? 320 : 180,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _parseColor(era).withValues(alpha: 0.15),
                          _parseColor(era).withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _parseColor(era).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Era Title
                          Text(
                            era.title.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: _parseColor(era),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            era.dateRange,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          if (!isExpanded) ...[
                            Text(
                              era.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lora(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                          ],

                          if (isExpanded) ...[
                            // Why It's Hard Section
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 16,
                                        color: Colors.red[300],
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          "WHY IT'S HARD",
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
                                            color: Colors.red[300],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    era.whyItsHard,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Reading Keys Section
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.key_rounded,
                                        size: 16,
                                        color: Colors.green[300],
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          "3 KEYS TO READING",
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
                                            color: Colors.green[300],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...era.readingKeys.asMap().entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${entry.key + 1}. ",
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[300],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: Colors.white.withValues(alpha: 0.9),
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _parseColor(BiblicalEra era) {
    final hex = era.title.toLowerCase().contains('creation') ? '#3B82F6'
        : era.title.toLowerCase().contains('patriarchs') ? '#8B5CF6'
        : era.title.toLowerCase().contains('exodus') ? '#10B981'
        : era.title.toLowerCase().contains('conquest') ? '#F59E0B'
        : era.title.toLowerCase().contains('united') ? '#EF4444'
        : era.title.toLowerCase().contains('divided') ? '#EC4899'
        : era.title.toLowerCase().contains('exile') ? '#6366F1'
        : era.title.toLowerCase().contains('christ') ? '#14B8A6'
        : '#F97316'; // Early Church
    
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
}
