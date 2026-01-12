import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../../../core/database/app_database.dart';
import '../../../journal/presentation/journal_providers.dart';
import '../../../journal/data/journal_repository.dart';
import '../../application/mentor_providers.dart';
import '../widgets/mentor_design.dart';

class LookForwardNoteSheet extends ConsumerStatefulWidget {
  final String theme;
  final String question;

  const LookForwardNoteSheet({
    super.key,
    required this.theme,
    required this.question,
  });

  @override
  ConsumerState<LookForwardNoteSheet> createState() => _LookForwardNoteSheetState();
}

class _LookForwardNoteSheetState extends ConsumerState<LookForwardNoteSheet> {
  final TextEditingController _noteController = TextEditingController();
  JournalEntry? _selectedEntry;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_selectedEntry == null || _noteController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final db = ref.read(appDatabaseProvider);
      final repo = JournalRepository(db);

      await repo.addLookForwardNote(
        entryId: _selectedEntry!.id,
        question: widget.question,
        note: _noteController.text.trim(),
        theme: widget.theme,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Action note attached to reflection',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: MentorDesign.themeColor(widget.theme),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save note: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = MentorDesign.themeColor(widget.theme);
    final entriesAsync = ref.watch(journalEntriesByThemeProvider(widget.theme));

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
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

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOOK FORWARD ACTION',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedEntry == null 
                    ? 'Which reflection is this about?' 
                    : 'What action will you take?',
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (widget.question.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.question,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (_selectedEntry == null)
            _buildEntrySelection(entriesAsync, themeColor)
          else
            _buildNoteInput(themeColor),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEntrySelection(AsyncValue<List<JournalEntry>> entriesAsync, Color themeColor) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return _buildEmptyEntries();
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildEntryCard(entry, themeColor);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildEntryCard(JournalEntry entry, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _selectedEntry = entry);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lora(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(entry.createdAt),
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, size: 16, color: themeColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteInput(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selected Entry Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: themeColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.quote, size: 14, color: Colors.white38),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedEntry!.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(fontSize: 12, color: Colors.white54, fontStyle: FontStyle.italic),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 14, color: Colors.white38),
                  onPressed: () => setState(() => _selectedEntry = null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          TextField(
            controller: _noteController,
            autofocus: true,
            maxLines: 5,
            style: GoogleFonts.lora(fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'I will...',
              hintStyle: GoogleFonts.lora(color: Colors.white24),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: _isSaving ? null : _saveNote,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isSaving
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('Save action Plan', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEntries() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(LucideIcons.searchX, size: 40, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'No reflections found for ${widget.theme}.\nJournal first to set a foundation.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 14, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}
