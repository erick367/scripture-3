import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/bible_constants.dart';
import 'version_switcher_sheet.dart';

class ChronologicalSliderWidget extends StatelessWidget {
  final String currentBook;
  final int currentChapter;
  final String currentVersion;
  final ValueChanged<String> onBookChanged;
  final ValueChanged<int> onChapterChanged;

  const ChronologicalSliderWidget({
    super.key,
    required this.currentBook,
    required this.currentChapter,
    required this.currentVersion,
    required this.onBookChanged,
    required this.onChapterChanged,
  });

  // Complete list of 66 Bible books organized by testament
  static const Map<String, List<String>> allBooks = {
    'Pentateuch': ['Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy'],
    'History': ['Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel', '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles', 'Ezra', 'Nehemiah', 'Esther'],
    'Poetry': ['Job', 'Psalms', 'Proverbs', 'Ecclesiastes', 'Song of Solomon'],
    'Major Prophets': ['Isaiah', 'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel'],
    'Minor Prophets': ['Hosea', 'Joel', 'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah', 'Malachi'],
    'Gospels': ['Matthew', 'Mark', 'Luke', 'John'],
    'Acts': ['Acts'],
    'Pauline Epistles': ['Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians', '1 Timothy', '2 Timothy', 'Titus', 'Philemon'],
    'General Epistles': ['Hebrews', 'James', '1 Peter', '2 Peter', '1 John', '2 John', '3 John', 'Jude'],
    'Apocalyptic': ['Revelation'],
  };

  String _getTestament(String book) {
    const otCategories = ['Pentateuch', 'History', 'Poetry', 'Major Prophets', 'Minor Prophets'];
    for (final cat in otCategories) {
      if (allBooks[cat]!.contains(book)) return 'Old Testament';
    }
    return 'New Testament';
  }

  String _getCategory(String book) {
    for (final entry in allBooks.entries) {
      if (entry.value.contains(book)) {
        return entry.key;
      }
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final testament = _getTestament(currentBook);
    final category = _getCategory(currentBook);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Version Switcher
            _buildBreadcrumbSegment(context, currentVersion, () {
               HapticFeedback.selectionClick();
               showModalBottomSheet(
                 context: context,
                 backgroundColor: Colors.transparent, // Glassmorphic sheet handles its own bg
                 isScrollControlled: true,
                 builder: (context) => const VersionSwitcherSheet(),
               );
            }, isActive: true, isVersion: true),
            
            Container(
              height: 12,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white24,
            ),

            _buildBreadcrumbSegment(context, testament, () {
              HapticFeedback.selectionClick();
              _showTestamentPicker(context);
            }),
            const Icon(LucideIcons.chevronRight, size: 14, color: Colors.white38),
            _buildBreadcrumbSegment(context, category, () {
              HapticFeedback.selectionClick();
              _showCategoryPicker(context, testament);
            }),
            const Icon(LucideIcons.chevronRight, size: 14, color: Colors.white38),
            _buildBreadcrumbSegment(context, currentBook, () {
              HapticFeedback.selectionClick();
              _showBookPicker(context, category);
            }),
            const Icon(LucideIcons.chevronRight, size: 14, color: Colors.white38),
            _buildBreadcrumbSegment(context, 'Ch $currentChapter', () {
              HapticFeedback.selectionClick();
              _showChapterPicker(context);
            }, isActive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbSegment(BuildContext context, String label, VoidCallback onTap, {bool isActive = false, bool isVersion = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: (isActive || isVersion) ? BoxDecoration(
          color: isVersion ? Colors.blue.withValues(alpha: 0.2) : Colors.amber.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: isVersion ? Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 1) : null,
        ) : null,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: (isActive || isVersion) ? FontWeight.bold : FontWeight.normal,
            color: isVersion ? Colors.blueAccent : (isActive ? Colors.amber : Colors.white54),
          ),
        ),
      ),
    );
  }

  void _showTestamentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Testament',
              style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTestamentChip(context, 'Old Testament', Icons.book),
                const SizedBox(width: 12),
                _buildTestamentChip(context, 'New Testament', Icons.auto_stories),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTestamentChip(BuildContext context, String testament, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          _showCategoryPicker(context, testament);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.amber, size: 32),
              const SizedBox(height: 8),
              Text(testament, style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, String testament) {
    final categories = testament == 'Old Testament'
        ? ['Pentateuch', 'History', 'Poetry', 'Major Prophets', 'Minor Prophets']
        : ['Gospels', 'Acts', 'Pauline Epistles', 'General Epistles', 'Apocalyptic'];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              testament,
              style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) => GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _showBookPicker(context, cat);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(cat, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showBookPicker(BuildContext context, String category) {
    final books = allBooks[category] ?? [];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isSelected = book == currentBook;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onBookChanged(book);
                        Navigator.pop(context);
                        // Optional: auto-show chapter picker after book selection
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.amber.withValues(alpha: 0.2) 
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected 
                              ? Border.all(color: Colors.amber, width: 2) 
                              : null,
                        ),
                        child: Text(
                          book,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.amber : Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChapterPicker(BuildContext context) {
    final chapterCount = BibleConstants.bookChapterCounts[currentBook] ?? 50;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$currentBook Chapters',
                style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: chapterCount,
                  itemBuilder: (context, index) {
                    final chapter = index + 1;
                    final isSelected = chapter == currentChapter;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onChapterChanged(chapter);
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.amber.withValues(alpha: 0.2) 
                              : Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: isSelected 
                              ? Border.all(color: Colors.amber, width: 2) 
                              : null,
                        ),
                        child: Text(
                          '$chapter',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.amber : Colors.white70,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
