import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/emotion_tags.dart';
import '../journal_providers.dart';
import 'emotion_chip.dart';

/// Glassmorphic journal entry editor modal
class JournalEntryEditor extends ConsumerStatefulWidget {
  final JournalEntry? existingEntry;

  const JournalEntryEditor({super.key, this.existingEntry});

  @override
  ConsumerState<JournalEntryEditor> createState() => _JournalEntryEditorState();
}

class _JournalEntryEditorState extends ConsumerState<JournalEntryEditor> {
  late TextEditingController _contentController;
  EmotionTag? _selectedEmotion;
  bool _aiMemoryEnabled = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.existingEntry?.content ?? '',
    );
    _selectedEmotion = EmotionTag.fromString(widget.existingEntry?.emotionTag);
    _aiMemoryEnabled = widget.existingEntry?.aiAccessEnabled ?? false;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Stack(
            children: [
              // Blur Effect
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.transparent),
              ),
              // Gradient Background & Border
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2A2A2A).withValues(alpha: 0.9),
                      const Color(0xFF2A2A2A).withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              // Content
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Grab Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Title
                    Text(
                      widget.existingEntry == null ? 'New Entry' : 'Edit Entry',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Verse Reference (if exists)
                    if (widget.existingEntry?.verseReference != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.bookmark, size: 16, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.existingEntry!.verseReference!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Content TextField
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: TextField(
                        controller: _contentController,
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText: 'What is stirring in your heart?',
                          hintStyle: GoogleFonts.lora(
                            fontSize: 16,
                            color: Colors.white38,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: 10,
                        minLines: 4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Emotion Picker
                    Text(
                      'How are you feeling?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    EmotionPicker(
                      selectedEmotion: _selectedEmotion,
                      onEmotionSelected: (emotion) {
                        setState(() => _selectedEmotion = emotion);
                      },
                    ),
                    const SizedBox(height: 24),

                    // AI Memory Toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.brain,
                            color: Colors.purpleAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Grant AI Memory',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Let the AI Mentor remember this reflection',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _aiMemoryEnabled,
                            onChanged: (value) {
                              HapticFeedback.lightImpact();
                              setState(() => _aiMemoryEnabled = value);
                            },
                            activeTrackColor: Colors.purpleAccent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : Text(
                                'Save Entry',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    HapticFeedback.lightImpact(); // Required haptic feedback

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(journalRepositoryProvider);

      if (widget.existingEntry == null) {
        // Create new entry
        await repo.saveEntry(
          content: content,
          aiAccessEnabled: _aiMemoryEnabled,
          emotionTag: _selectedEmotion?.label,
          verseReference: null, // Can be passed from Bible reader context
        );
      } else {
        // Update existing entry
        await repo.updateEntry(
          widget.existingEntry!.id,
          content: content,
          emotionTag: _selectedEmotion?.label,
          aiAccessEnabled: _aiMemoryEnabled,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving entry: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving entry: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
