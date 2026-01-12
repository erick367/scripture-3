import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../application/theme_service.dart';

class ThemeCloudWidget extends StatefulWidget {
  final List<SpiritualTheme> themes;

  const ThemeCloudWidget({super.key, required this.themes});

  @override
  State<ThemeCloudWidget> createState() => _ThemeCloudWidgetState();
}

class _ThemeCloudWidgetState extends State<ThemeCloudWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.themes.isEmpty) {
      return _buildEmptyState();
    }

    // Find max frequency for scaling
    final maxFreq = widget.themes.map((t) => t.frequency).reduce((a, b) => a > b ? a : b);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: widget.themes.asMap().entries.map((entry) {
        final index = entry.key;
        final theme = entry.value;
        
        // Staggered animation
        final begin = (index * 0.1).clamp(0.0, 1.0);
        final end = (begin + 0.5).clamp(0.0, 1.0);
        
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeOut),
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: _buildThemeChip(theme, maxFreq),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThemeChip(SpiritualTheme theme, int maxFreq) {
    // Size scales with frequency (1.0 to 1.5)
    final scale = 1.0 + (theme.frequency / maxFreq) * 0.5;
    
    // Color varies by position
    final colors = [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.tealAccent,
      Colors.amberAccent,
      Colors.pinkAccent,
    ];
    final color = colors[widget.themes.indexOf(theme) % colors.length];

    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Standardized per Rule 01
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
              vertical: 10 * scale,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Text(
              theme.name,
              style: GoogleFonts.inter(
                fontSize: 14 * scale,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Journal more to discover your themes',
          style: GoogleFonts.lora(
            fontSize: 14,
            color: Colors.white54,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
