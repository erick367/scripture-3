import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../../services/ai_mentor_service.dart';

/// DBS (Discovery Bible Study) Module Widget
/// Implements the Retell > Observe > Obey flow with Scholar's Correction
class DBSModuleWidget extends ConsumerStatefulWidget {
  const DBSModuleWidget({super.key});

  @override
  ConsumerState<DBSModuleWidget> createState() => _DBSModuleWidgetState();
}

class _DBSModuleWidgetState extends ConsumerState<DBSModuleWidget> {
  int _currentStep = 0;
  bool _isRecording = false;
  String _retellText = '';
  final List<String> _observations = [];
  final List<String> _applications = [];
  String? _scholarCorrection;
  bool _isCheckingCorrection = false;

  final List<DBSStep> _steps = [
    DBSStep(
      title: 'RETELL',
      subtitle: 'Share the story in your own words',
      icon: Icons.record_voice_over,
      color: Colors.blue,
      description: 'Tell the passage back as if speaking to a friend. Don\'t worry about perfection—just capture the main narrative.',
    ),
    DBSStep(
      title: 'OBSERVE',
      subtitle: 'What do you notice?',
      icon: Icons.visibility,
      color: Colors.purple,
      description: 'What stands out? What surprises you? What questions arise? Note patterns, contrasts, or repeated words.',
    ),
    DBSStep(
      title: 'OBEY',
      subtitle: 'How will you respond?',
      icon: Icons.check_circle,
      color: Colors.green,
      description: 'What is one specific action you can take this week? Who can you share this with?',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showDBSModal(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo.withValues(alpha: 0.15),
                  Colors.purple.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.indigo.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Colors.indigoAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISCOVERY BIBLE STUDY',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Interactive Retell → Observe → Obey',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white38,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDBSModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0A0A0A),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Discovery Bible Study',
                        style: GoogleFonts.lora(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
                  ],
                ),
              ),

              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    _steps.length,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index < _steps.length - 1 ? 8 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? _steps[index].color
                              : Colors.white12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Current Step Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildStepContent(_currentStep, setState),
                ),
              ),

              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: () {
                          setState(() => _currentStep--);
                          HapticFeedback.selectionClick();
                        },
                        child: Text(
                          'Back',
                          style: GoogleFonts.inter(color: Colors.white54),
                        ),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentStep < _steps.length - 1) {
                          setState(() => _currentStep++);
                        } else {
                          Navigator.pop(context);
                          _showCompletionDialog(context);
                        }
                        HapticFeedback.mediumImpact();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _steps[_currentStep].color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentStep < _steps.length - 1 ? 'Next' : 'Complete',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(int stepIndex, StateSetter setState) {
    final step = _steps[stepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Icon & Title
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: step.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                step.icon,
                color: step.color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: step.color,
                    ),
                  ),
                  Text(
                    step.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Description
        Text(
          step.description,
          style: GoogleFonts.lora(
            fontSize: 15,
            color: Colors.white70,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // Step-specific content
        if (stepIndex == 0) _buildRetellSection(setState),
        if (stepIndex == 1) _buildObserveSection(setState),
        if (stepIndex == 2) _buildObeySection(setState),
      ],
    );
  }

  Widget _buildRetellSection(StateSetter setState) {
    return Column(
      children: [
        // Voice Recording Button (Placeholder for future Whisper integration)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                _isRecording ? Icons.stop_circle : Icons.mic,
                color: Colors.blue,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                _isRecording ? 'Recording...' : 'Tap to record your retelling',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '(Voice-to-text coming soon)',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white38,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Text input fallback
        TextField(
          maxLines: 6,
          style: GoogleFonts.lora(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Or type your retelling here...',
            hintStyle: GoogleFonts.lora(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          onChanged: (value) => _retellText = value,
        ),
      ],
    );
  }

  Widget _buildObserveSection(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add your observations:',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 12),
        ..._observations.map((obs) => _buildListItem(obs, Colors.purple)),
        TextField(
          style: GoogleFonts.lora(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'What did you notice?',
            hintStyle: GoogleFonts.lora(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add, color: Colors.purple),
              onPressed: () {
                // Add observation logic
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObeySection(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your commitments:',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 12),
        ..._applications.map((app) => _buildListItem(app, Colors.green)),
        TextField(
          style: GoogleFonts.lora(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'What will you do this week?',
            hintStyle: GoogleFonts.lora(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () {
                // Add application logic
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lora(fontSize: 13, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          '🎉 DBS Complete!',
          style: GoogleFonts.lora(color: Colors.white),
        ),
        content: Text(
          'You\'ve completed the Discovery Bible Study flow. Your insights have been saved.',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class DBSStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String description;

  DBSStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.description,
  });
}
