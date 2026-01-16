import 'models/verse_insight.dart';

/// Provides instant placeholder insights while AI generates the real response
class OptimisticInsightProvider {
  /// Get an instant generic insight based on the verse reference
  static VerseInsight getPlaceholderInsight(String verseReference, String verseText) {
    return VerseInsight(
      naturalMeaning: 'Analyzing the deeper meaning of this passage...',
      originalContext: 'Examining the original Greek/Hebrew context and historical background...',
      soWhat: 'Discovering how this truth applies to your life today...',
      scenario: 'Finding a practical example that brings this to life...',
      threads: [
        'Searching for related verses and themes...',
        'Connecting this to the broader Biblical narrative...',
      ],
    );
  }
  
  /// Get a more contextual placeholder based on common verse themes
  static VerseInsight getSmartPlaceholder(String verseReference, String verseText) {
    // Simple keyword matching for common themes
    final lowerText = verseText.toLowerCase();
    
    if (lowerText.contains('love') || lowerText.contains('beloved')) {
      return VerseInsight(
        naturalMeaning: 'This passage speaks to the profound nature of divine love and how it transforms us.',
        originalContext: 'The original language reveals layers of meaning about unconditional love...',
        soWhat: 'This calls us to love others with the same grace we\'ve received.',
        scenario: 'Consider how you can show this kind of love in your relationships today.',
        threads: [
          '1 Corinthians 13 - The nature of love',
          'John 3:16 - God\'s love for the world',
        ],
      );
    }
    
    if (lowerText.contains('faith') || lowerText.contains('believe')) {
      return VerseInsight(
        naturalMeaning: 'This verse challenges us to trust beyond what we can see or understand.',
        originalContext: 'The Biblical concept of faith involves both trust and action...',
        soWhat: 'Faith isn\'t passive belief - it\'s active trust that changes how we live.',
        scenario: 'What area of your life requires you to step out in faith today?',
        threads: [
          'Hebrews 11:1 - The definition of faith',
          'James 2:17 - Faith without works',
        ],
      );
    }
    
    if (lowerText.contains('word') || lowerText.contains('beginning')) {
      return VerseInsight(
        naturalMeaning: 'This passage reveals the eternal nature and creative power of God\'s Word.',
        originalContext: 'The Greek "Logos" carries profound philosophical and theological weight...',
        soWhat: 'God\'s Word is not just information - it\'s the living force that creates and sustains reality.',
        scenario: 'How does viewing Scripture as "living and active" change your approach to reading it?',
        threads: [
          'Genesis 1:1 - In the beginning',
          'Hebrews 4:12 - The Word is living and active',
        ],
      );
    }
    
    // Default generic placeholder
    return getPlaceholderInsight(verseReference, verseText);
  }
}
