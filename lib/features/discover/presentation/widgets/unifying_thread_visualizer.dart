import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

/// Unifying Thread Visualizer
/// Shows 5 major biblical themes and allows users to trace them through Scripture
class UnifyingThreadVisualizer extends StatefulWidget {
  const UnifyingThreadVisualizer({super.key});

  @override
  State<UnifyingThreadVisualizer> createState() => _UnifyingThreadVisualizerState();
}

class _UnifyingThreadVisualizerState extends State<UnifyingThreadVisualizer> {
  int? _selectedThemeIndex;

  final List<BiblicalTheme> _themes = const [
    BiblicalTheme(
      name: 'Kingdom',
      icon: Icons.castle,
      color: Color(0xFF8B5CF6),
      description: 'God\'s rule and reign from Eden to the New Jerusalem',
      keyVerses: ['Gen 1:26-28', 'Dan 2:44', 'Matt 6:10', 'Rev 11:15'],
    ),
    BiblicalTheme(
      name: 'Covenant',
      icon: Icons.handshake,
      color: Color(0xFF3B82F6),
      description: 'God\'s binding promises with Noah, Abraham, Moses, David, and Jesus',
      keyVerses: ['Gen 9:9', 'Gen 15:18', 'Ex 24:8', '2 Sam 7:16', 'Luke 22:20'],
    ),
    BiblicalTheme(
      name: 'Sacrifice',
      icon: Icons.favorite,
      color: Color(0xFFEF4444),
      description: 'Substitutionary atonement from Abel to Calvary',
      keyVerses: ['Gen 4:4', 'Lev 16', 'Isa 53:10', 'John 1:29', 'Heb 10:10'],
    ),
    BiblicalTheme(
      name: 'Presence',
      icon: Icons.wb_sunny,
      color: Color(0xFFF59E0B),
      description: 'God dwelling with His people: Eden, Tabernacle, Temple, Christ, us',
      keyVerses: ['Gen 3:8', 'Ex 40:34', '1 Kings 8:10', 'John 1:14', 'Rev 21:3'],
    ),
    BiblicalTheme(
      name: 'Wisdom',
      icon: Icons.school,
      color: Color(0xFF10B981),
      description: 'Living skillfully under God\'s order: from Proverbs to the Incarnate Wisdom',
      keyVerses: ['Prov 1:7', 'Prov 8:22-31', 'Matt 11:19', '1 Cor 1:24', 'Col 2:3'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Theme selector chips
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _themes.length,
            itemBuilder: (context, index) {
              final theme = _themes[index];
              final isSelected = _selectedThemeIndex == index;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _selectedThemeIndex = isSelected ? null : index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 200 : 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.color.withValues(alpha: isSelected ? 0.25 : 0.15),
                              theme.color.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.color.withValues(alpha: isSelected ? 0.5 : 0.3),
                            width: isSelected ? 2 : 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              theme.icon,
                              color: theme.color,
                              size: isSelected ? 40 : 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              theme.name.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: isSelected ? 14 : 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: theme.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isSelected) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${theme.keyVerses.length} key verses',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Theme details (when selected)
        if (_selectedThemeIndex != null) ...[
          const SizedBox(height: 16),
          _buildThemeDetailsCard(_themes[_selectedThemeIndex!]),
        ],
      ],
    );
  }

  Widget _buildThemeDetailsCard(BiblicalTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            theme.description,
            style: GoogleFonts.lora(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Key Verses
          Text(
            'KEY VERSES',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: theme.color,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: theme.keyVerses.map((verse) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  verse,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Trace in My Reading button
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showTracingDialog(theme);
            },
            icon: const Icon(Icons.search, size: 18),
            label: Text(
              'Trace in My Reading',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTracingDialog(BiblicalTheme theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Row(
          children: [
            Icon(theme.icon, color: theme.color, size: 24),
            const SizedBox(width: 12),
            Text(
              '${theme.name} Thread',
              style: GoogleFonts.lora(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vector search will find all verses in your reading history that connect to this theme.',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Coming Soon: Requires vector embeddings',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class BiblicalTheme {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> keyVerses;

  const BiblicalTheme({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.keyVerses,
  });
}
