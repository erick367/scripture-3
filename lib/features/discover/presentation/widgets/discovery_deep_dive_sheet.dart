import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;

import '../../../../services/ai_mentor_service.dart';
import '../../data/archaeology_repository.dart';

class DiscoveryDeepDiveSheet extends ConsumerStatefulWidget {
  final Discovery discovery;

  const DiscoveryDeepDiveSheet({super.key, required this.discovery});

  @override
  ConsumerState<DiscoveryDeepDiveSheet> createState() => _DiscoveryDeepDiveSheetState();
}

class _DiscoveryDeepDiveSheetState extends ConsumerState<DiscoveryDeepDiveSheet> {
  String? _aiResponse;
  bool _isLoading = false;

  Future<void> _askMentor() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    final service = ref.read(aiMentorServiceProvider);
    final response = await service.getDiscoveryContext(
      discoveryName: widget.discovery.title,
      connectedVerse: widget.discovery.connectedVerse,
      description: widget.discovery.description,
    );

    if (mounted) {
      setState(() {
        _aiResponse = response;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Stack(
            children: [
              // Glass Background
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Standardized per Rule 01
                child: Container(
                  color: const Color(0xFF0A0A0A).withValues(alpha: 0.8),
                ),
              ),
              
              // Content
              ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  // Image Header (Placeholder)
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      // In real app: image: DecorationImage(image: AssetImage(widget.discovery.imageUrl), fit: BoxFit.cover),
                    ),
                    child: Center(
                      child: Icon(LucideIcons.image, size: 64, color: Colors.white24),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Meta
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                widget.discovery.dateFound,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              widget.discovery.location,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.discovery.title,
                          style: GoogleFonts.lora(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          widget.discovery.description,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Connected Verse
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.link, color: Colors.blueAccent, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                "Connected Verse: ${widget.discovery.connectedVerse}",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Why It Matters (Theological Bridge)
                        if (widget.discovery.whyItMatters != null) ...[
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.amber.withValues(alpha: 0.15),
                                  Colors.orange.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.amber.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.lightbulb,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'WHY IT MATTERS',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.discovery.whyItMatters!,
                                  style: GoogleFonts.lora(
                                    fontSize: 15,
                                    color: Colors.white.withValues(alpha: 0.95),
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // AI Context Bridge
                        if (_aiResponse == null) ...[
                          GestureDetector(
                            onTap: _isLoading ? null : _askMentor,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF6366F1).withValues(alpha: 0.2),
                                    const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                              ),
                              child: _isLoading 
                                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Ask Mentor: Validity Connection",
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(LucideIcons.bot, color: Color(0xFF6366F1), size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Mentor Insight",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF6366F1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _aiResponse!,
                                  style: GoogleFonts.lora(
                                    fontSize: 15,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 50), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
              
              // Close Handle
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Close Button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
