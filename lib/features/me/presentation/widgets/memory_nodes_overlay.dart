import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math';

class MemoryNodesOverlay extends StatelessWidget {
  final List<dynamic> entries; // JournalEntry list

  const MemoryNodesOverlay({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    // Get last 5 entries with verse references to act as nodes
    final nodeEntries = entries
        .where((e) => e.verseReference != null && e.verseReference!.isNotEmpty)
        .take(5)
        .toList();

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        children: [
          for (int i = 0; i < nodeEntries.length; i++)
            _buildNode(context, nodeEntries[i], i),
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, dynamic entry, int index) {
    // Randomish but stable positions around the center of the sphere
    final random = Random(entry.id.hashCode);
    final top = 100 + random.nextDouble() * 150;
    final left = 50 + random.nextDouble() * (MediaQuery.of(context).size.width - 100);

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => _handleNodeTap(context, entry),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 800 + (index * 200)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: child,
              ),
            );
          },
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, dynamic entry) async {
    // 1. Heartbeat double-pulse haptic
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();

    // 2. Show Glassmorphic Card
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.verseReference ?? 'Verse',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'STAY IN THE LIGHT',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white38,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
