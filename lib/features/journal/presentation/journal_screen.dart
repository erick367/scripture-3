import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/database/app_database.dart';
import '../domain/emotion_tags.dart';
import 'journal_providers.dart';
import 'widgets/journal_entry_editor.dart';
import 'widgets/spiritual_pulse_dashboard.dart';
import '../domain/look_forward_note.dart';
import 'package:intl/intl.dart';

/// Main journal screen showing list of all entries
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Journal',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: Colors.white),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showEntryEditor(context, ref);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dashboard is always visible at the top
          const SpiritualPulseDashboard(),
          
          Expanded(
            child: entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildEntryList(entries, context, ref);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading entries: $error',
                  style: GoogleFonts.inter(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Your journey here is just beginning.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 20,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap + to create your first entry',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryList(List<JournalEntry> entries, BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildEntryCard(entry, context, ref);
      },
    );
  }

  Widget _buildEntryCard(JournalEntry entry, BuildContext context, WidgetRef ref) {
    final emotion = EmotionTag.fromString(entry.emotionTag);
    final timeDiff = DateTime.now().difference(entry.createdAt);
    String timeLabel;
    
    if (timeDiff.inDays == 0) {
      timeLabel = 'Today';
    } else if (timeDiff.inDays == 1) {
      timeLabel = 'Yesterday';
    } else if (timeDiff.inDays < 7) {
      timeLabel = '${timeDiff.inDays} days ago';
    } else {
      timeLabel = '${entry.createdAt.month}/${entry.createdAt.day}/${entry.createdAt.year}';
    }

    return Dismissible(
      key: Key(entry.id.toString()),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(LucideIcons.trash2, color: Colors.red),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        HapticFeedback.mediumImpact();
        await ref.read(journalRepositoryProvider).deleteEntry(entry.id);
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showEntryEditor(context, ref, entry: entry);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (emotion != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: emotion.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: emotion.color.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(emotion.icon, size: 12, color: emotion.color),
                          const SizedBox(width: 4),
                          Text(
                            emotion.label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: emotion.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (entry.verseReference != null)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.verseReference!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    timeLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry.content.length > 120
                    ? '${entry.content.substring(0, 120)}...'
                    : entry.content,
                style: GoogleFonts.lora(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              
              // Display Look Forward Notes if any
              if (entry.lookForwardNotes != null && entry.lookForwardNotes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildLookForwardSection(entry.lookForwardNotes!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLookForwardSection(String jsonNotes) {
    final notes = LookForwardNote.parseList(jsonNotes);
    if (notes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.listTodo, size: 12, color: Colors.greenAccent),
            const SizedBox(width: 6),
            Text(
              'ACTION PLAN',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.greenAccent,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...notes.map((note) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Look Forward note from ${DateFormat('MMM d, h:mm a').format(note.createdAt)}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: Colors.greenAccent.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                note.note,
                style: GoogleFonts.lora(
                  fontSize: 13,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              if (note.question.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Q: ${note.question}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white38,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }

  void _showEntryEditor(BuildContext context, WidgetRef ref, {JournalEntry? entry}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JournalEntryEditor(existingEntry: entry),
    );
  }
}
