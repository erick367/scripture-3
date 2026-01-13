import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local RAG Dictionary Service
/// 
/// Provides instant (<10ms) definitions for Greek and Hebrew biblical terms.
/// Uses a bundled dictionary for offline access.
/// Falls back to Qwen for terms not in dictionary.
class LocalRagDictionary {
  /// Get a definition for a biblical term
  /// 
  /// Returns the definition if found in local dictionary, null otherwise.
  DictionaryEntry? getDefinition(String term) {
    final normalized = term.toLowerCase().trim();
    
    // Check Greek dictionary
    final greek = _greekDictionary[normalized];
    if (greek != null) return greek;
    
    // Check Hebrew dictionary
    final hebrew = _hebrewDictionary[normalized];
    if (hebrew != null) return hebrew;
    
    // Check theological terms
    final theological = _theologicalTerms[normalized];
    if (theological != null) return theological;
    
    return null;
  }
  
  /// Search for terms matching a query
  List<DictionaryEntry> search(String query) {
    final normalized = query.toLowerCase().trim();
    final results = <DictionaryEntry>[];
    
    for (final dict in [_greekDictionary, _hebrewDictionary, _theologicalTerms]) {
      for (final entry in dict.values) {
        if (entry.term.toLowerCase().contains(normalized) ||
            entry.definition.toLowerCase().contains(normalized)) {
          results.add(entry);
        }
      }
    }
    
    return results..sort((a, b) => a.term.compareTo(b.term));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Greek Dictionary (Koine Greek)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const _greekDictionary = <String, DictionaryEntry>{
    // A
    'agape': DictionaryEntry(
      term: 'Ἀγάπη (Agape)',
      language: 'Greek',
      transliteration: 'agapē',
      definition: 'Unconditional, self-sacrificial love. Unlike eros (romantic) or philia (friendship), agape describes God\'s love for humanity and the love Christians are called to show—a deliberate choice to seek another\'s highest good regardless of feelings.',
      strongsNumber: 'G26',
      usageExample: 'John 3:16 - "For God so loved (ἠγάπησεν) the world..."',
    ),
    'logos': DictionaryEntry(
      term: 'Λόγος (Logos)',
      language: 'Greek',
      transliteration: 'logos',
      definition: 'Word, reason, or divine expression. In John 1:1, it refers to Jesus as the eternal Word through whom all things were made—God\'s self-expression and communication to humanity.',
      strongsNumber: 'G3056',
      usageExample: 'John 1:1 - "In the beginning was the Word (Λόγος)..."',
    ),
    'pistis': DictionaryEntry(
      term: 'Πίστις (Pistis)',
      language: 'Greek',
      transliteration: 'pistis',
      definition: 'Faith, trust, or conviction. More than intellectual belief—it implies active trust and commitment, like a chair you actually sit in rather than merely believe can hold you.',
      strongsNumber: 'G4102',
      usageExample: 'Hebrews 11:1 - "Now faith (πίστις) is the substance of things hoped for..."',
    ),
    'charis': DictionaryEntry(
      term: 'Χάρις (Charis)',
      language: 'Greek',
      transliteration: 'charis',
      definition: 'Grace, favor, or gift freely given. In the New Testament, it describes God\'s unmerited favor toward humanity—a gift that cannot be earned but only received.',
      strongsNumber: 'G5485',
      usageExample: 'Ephesians 2:8 - "For by grace (χάριτι) you have been saved..."',
    ),
    'shalom': DictionaryEntry(
      term: 'Εἰρήνη (Eirene)',
      language: 'Greek',
      transliteration: 'eirēnē',
      definition: 'Peace, wholeness, or harmony. The Greek equivalent of Hebrew "shalom"—not merely absence of conflict but complete well-being in relationship with God and others.',
      strongsNumber: 'G1515',
      usageExample: 'John 14:27 - "Peace (εἰρήνην) I leave with you..."',
    ),
    'metanoia': DictionaryEntry(
      term: 'Μετάνοια (Metanoia)',
      language: 'Greek',
      transliteration: 'metanoia',
      definition: 'Repentance or a change of mind. Literally "after-mind"—a complete transformation of thinking and direction, turning away from sin toward God.',
      strongsNumber: 'G3341',
      usageExample: 'Acts 2:38 - "Repent (μετανοήσατε) and be baptized..."',
    ),
    'doxa': DictionaryEntry(
      term: 'Δόξα (Doxa)',
      language: 'Greek',
      transliteration: 'doxa',
      definition: 'Glory, honor, or splendor. Describes the visible manifestation of God\'s presence and majesty—the weight and significance that demands a response.',
      strongsNumber: 'G1391',
      usageExample: 'John 1:14 - "We beheld his glory (δόξαν)..."',
    ),
    'pneuma': DictionaryEntry(
      term: 'Πνεῦμα (Pneuma)',
      language: 'Greek',
      transliteration: 'pneuma',
      definition: 'Spirit, breath, or wind. Used for the Holy Spirit (Πνεῦμα Ἅγιον), the human spirit, and spiritual realities. Suggests both power and invisibility.',
      strongsNumber: 'G4151',
      usageExample: 'John 4:24 - "God is Spirit (πνεῦμα)..."',
    ),
    'sozo': DictionaryEntry(
      term: 'Σῴζω (Sozo)',
      language: 'Greek',
      transliteration: 'sōzō',
      definition: 'To save, rescue, or heal. Encompasses physical healing, deliverance from danger, and spiritual salvation—total restoration of the whole person.',
      strongsNumber: 'G4982',
      usageExample: 'Romans 10:9 - "You will be saved (σωθήσῃ)..."',
    ),
    'zoe': DictionaryEntry(
      term: 'Ζωή (Zoe)',
      language: 'Greek',
      transliteration: 'zōē',
      definition: 'Life—specifically the quality of life that comes from God. Distinguished from bios (physical existence), zoe refers to eternal, abundant life.',
      strongsNumber: 'G2222',
      usageExample: 'John 10:10 - "I came that they may have life (ζωὴν)..."',
    ),
    'aletheia': DictionaryEntry(
      term: 'Ἀλήθεια (Aletheia)',
      language: 'Greek',
      transliteration: 'alētheia',
      definition: 'Truth, reality, or genuineness. Literally "un-hidden"—that which is revealed and corresponds to reality. Jesus claims to be the Truth itself.',
      strongsNumber: 'G225',
      usageExample: 'John 14:6 - "I am the way, the truth (ἀλήθεια), and the life..."',
    ),
    'dunamis': DictionaryEntry(
      term: 'Δύναμις (Dunamis)',
      language: 'Greek',
      transliteration: 'dunamis',
      definition: 'Power, might, or ability. The root of "dynamite" and "dynamic"—God\'s inherent capability to accomplish His purposes.',
      strongsNumber: 'G1411',
      usageExample: 'Acts 1:8 - "You will receive power (δύναμιν)..."',
    ),
    'koinonia': DictionaryEntry(
      term: 'Κοινωνία (Koinonia)',
      language: 'Greek',
      transliteration: 'koinōnia',
      definition: 'Fellowship, communion, or sharing. Deep relational connection in the early church—sharing life, resources, and spiritual bond together.',
      strongsNumber: 'G2842',
      usageExample: 'Acts 2:42 - "They devoted themselves to...fellowship (κοινωνίᾳ)..."',
    ),
    'euangelion': DictionaryEntry(
      term: 'Εὐαγγέλιον (Euangelion)',
      language: 'Greek',
      transliteration: 'euangelion',
      definition: 'Good news or gospel. In the Roman world, it announced imperial victories. The NT uses it for the announcement of God\'s saving work in Jesus.',
      strongsNumber: 'G2098',
      usageExample: 'Mark 1:1 - "The beginning of the gospel (εὐαγγελίου)..."',
    ),
    'parakletos': DictionaryEntry(
      term: 'Παράκλητος (Parakletos)',
      language: 'Greek',
      transliteration: 'paraklētos',
      definition: 'Advocate, comforter, or helper. One called alongside to help. Used for the Holy Spirit who counsels, encourages, and intercedes.',
      strongsNumber: 'G3875',
      usageExample: 'John 14:16 - "He will give you another Helper (Παράκλητον)..."',
    ),
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Hebrew Dictionary (Biblical Hebrew)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const _hebrewDictionary = <String, DictionaryEntry>{
    'shalom': DictionaryEntry(
      term: 'שָׁלוֹם (Shalom)',
      language: 'Hebrew',
      transliteration: 'shālôm',
      definition: 'Peace, completeness, welfare, or wholeness. Far more than absence of war—it describes total well-being, prosperity, and right relationship with God and others.',
      strongsNumber: 'H7965',
      usageExample: 'Numbers 6:26 - "...and give you peace (שָׁלוֹם)."',
    ),
    'hesed': DictionaryEntry(
      term: 'חֶסֶד (Hesed)',
      language: 'Hebrew',
      transliteration: 'ḥesed',
      definition: 'Steadfast love, lovingkindness, or loyal love. Describes God\'s faithful, covenant-keeping love that never gives up—mercy and grace combined.',
      strongsNumber: 'H2617',
      usageExample: 'Psalm 136:1 - "His steadfast love (חַסְדּוֹ) endures forever."',
    ),
    'ruach': DictionaryEntry(
      term: 'רוּחַ (Ruach)',
      language: 'Hebrew',
      transliteration: 'rûaḥ',
      definition: 'Spirit, wind, or breath. Used for God\'s Spirit, human spirit, and wind. Suggests both power and life-giving force.',
      strongsNumber: 'H7307',
      usageExample: 'Genesis 1:2 - "The Spirit (רוּחַ) of God was hovering..."',
    ),
    'yasha': DictionaryEntry(
      term: 'יָשַׁע (Yasha)',
      language: 'Hebrew',
      transliteration: 'yāšaʿ',
      definition: 'To save, deliver, or rescue. The root of "Joshua" and "Jesus" (Yeshua). Implies deliverance from danger into safety and spaciousness.',
      strongsNumber: 'H3467',
      usageExample: 'Psalm 118:21 - "You have saved (הוֹשַׁעְתָּנִי) me..."',
    ),
    'amen': DictionaryEntry(
      term: 'אָמֵן (Amen)',
      language: 'Hebrew',
      transliteration: 'ʾāmēn',
      definition: '"So be it" or "truly." An affirmation of truth and trustworthiness. Related to "emunah" (faithfulness). Jesus uses it to introduce authoritative statements.',
      strongsNumber: 'H543',
      usageExample: 'Revelation 3:14 - "The Amen (Ἀμήν), the faithful witness..."',
    ),
    'torah': DictionaryEntry(
      term: 'תּוֹרָה (Torah)',
      language: 'Hebrew',
      transliteration: 'tôrâ',
      definition: 'Instruction, teaching, or law. More than rules—it\'s God\'s loving guidance for life. The first five books of the Bible.',
      strongsNumber: 'H8451',
      usageExample: 'Psalm 119:1 - "Blessed are those whose way is blameless, who walk in the law (תוֹרַת) of the LORD."',
    ),
    'kadosh': DictionaryEntry(
      term: 'קָדוֹשׁ (Kadosh)',
      language: 'Hebrew',
      transliteration: 'qādôš',
      definition: 'Holy, set apart, or sacred. Describes God\'s transcendent otherness and the calling for His people to be distinct.',
      strongsNumber: 'H6918',
      usageExample: 'Isaiah 6:3 - "Holy (קָדוֹשׁ), holy, holy is the LORD of hosts..."',
    ),
    'emunah': DictionaryEntry(
      term: 'אֱמוּנָה (Emunah)',
      language: 'Hebrew',
      transliteration: 'ʾĕmûnâ',
      definition: 'Faithfulness, reliability, or steadfastness. Not just belief, but firm commitment and trustworthiness—both God\'s toward us and ours toward Him.',
      strongsNumber: 'H530',
      usageExample: 'Habakkuk 2:4 - "The righteous shall live by his faith (בֶּאֱמוּנָתוֹ)."',
    ),
    'bara': DictionaryEntry(
      term: 'בָּרָא (Bara)',
      language: 'Hebrew',
      transliteration: 'bārāʾ',
      definition: 'To create—exclusively used with God as subject. Implies creation from nothing, divine initiative, and effortless execution.',
      strongsNumber: 'H1254',
      usageExample: 'Genesis 1:1 - "God created (בָּרָא) the heavens and the earth."',
    ),
    'mashiach': DictionaryEntry(
      term: 'מָשִׁיחַ (Mashiach)',
      language: 'Hebrew',
      transliteration: 'māšîaḥ',
      definition: 'Anointed one, Messiah. Originally for kings invited into God\'s purposes. Later, the awaited deliverer who would restore Israel.',
      strongsNumber: 'H4899',
      usageExample: 'Daniel 9:25 - "Until Messiah (מָשִׁיחַ) the Prince..."',
    ),
    'kabod': DictionaryEntry(
      term: 'כָּבוֹד (Kabod)',
      language: 'Hebrew',
      transliteration: 'kābôd',
      definition: 'Glory, honor, or weight. God\'s manifest presence—heavy with significance and demanding a response. The visible display of divine majesty.',
      strongsNumber: 'H3519',
      usageExample: 'Exodus 33:18 - "Please show me your glory (כְּבֹדֶךָ)."',
    ),
    'teshuvah': DictionaryEntry(
      term: 'תְּשׁוּבָה (Teshuvah)',
      language: 'Hebrew',
      transliteration: 'tešûḇâ',
      definition: 'Return, repentance, or answer. The act of turning back to God—central to Jewish spirituality, especially during High Holy Days.',
      strongsNumber: 'H8666',
      usageExample: 'Isaiah 30:15 - "In returning (בְּשׁוּבָה) and rest you shall be saved."',
    ),
    'berith': DictionaryEntry(
      term: 'בְּרִית (Berith)',
      language: 'Hebrew',
      transliteration: 'bərîṯ',
      definition: 'Covenant, agreement, or treaty. God\'s binding commitment to His people—the framework of biblical relationship.',
      strongsNumber: 'H1285',
      usageExample: 'Genesis 15:18 - "The LORD made a covenant (בְרִית) with Abram..."',
    ),
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Theological Terms
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const _theologicalTerms = <String, DictionaryEntry>{
    'justification': DictionaryEntry(
      term: 'Justification',
      language: 'Theological',
      transliteration: 'dikaiosis (δικαίωσις)',
      definition: 'God\'s legal declaration that a sinner is righteous based on faith in Christ. Not making someone righteous, but declaring them so—like a judge\'s verdict.',
      usageExample: 'Romans 5:18 - "...one act of righteousness leads to justification and life for all."',
    ),
    'sanctification': DictionaryEntry(
      term: 'Sanctification',
      language: 'Theological',
      transliteration: 'hagiasmos (ἁγιασμός)',
      definition: 'The ongoing process of becoming holy. After justification (declared righteous), sanctification is the Spirit\'s work making us actually righteous over time.',
      usageExample: '1 Thessalonians 4:3 - "For this is the will of God, your sanctification..."',
    ),
    'redemption': DictionaryEntry(
      term: 'Redemption',
      language: 'Theological',
      transliteration: 'apolytrosis (ἀπολύτρωσις)',
      definition: 'To buy back or release through payment. Christ\'s death is the ransom price that frees us from slavery to sin and death.',
      usageExample: 'Ephesians 1:7 - "In him we have redemption through his blood..."',
    ),
    'atonement': DictionaryEntry(
      term: 'Atonement',
      language: 'Theological',
      transliteration: 'hilasmos (ἱλασμός)',
      definition: 'The act of making amends for sin. Christ\'s sacrifice satisfies divine justice and restores relationship—at-one-ment with God.',
      usageExample: '1 John 2:2 - "He is the propitiation for our sins..."',
    ),
    'propitiation': DictionaryEntry(
      term: 'Propitiation',
      language: 'Theological',
      transliteration: 'hilasterion (ἱλαστήριον)',
      definition: 'The turning away of wrath through a sacrifice. Christ absorbed divine judgment against sin, satisfying God\'s righteous anger.',
      usageExample: 'Romans 3:25 - "God put forward as a propitiation by his blood..."',
    ),
    'eschatology': DictionaryEntry(
      term: 'Eschatology',
      language: 'Theological',
      transliteration: 'eschatos (ἔσχατος) + logos',
      definition: 'The study of "last things"—death, judgment, heaven, hell, the return of Christ, and the final consummation of God\'s kingdom.',
      usageExample: 'Revelation 21:1 - "Then I saw a new heaven and a new earth..."',
    ),
    'incarnation': DictionaryEntry(
      term: 'Incarnation',
      language: 'Theological',
      transliteration: 'ensarkosis',
      definition: 'God becoming flesh in Jesus Christ. The Second Person of the Trinity took on human nature—fully God and fully man.',
      usageExample: 'John 1:14 - "The Word became flesh and dwelt among us..."',
    ),
    'trinity': DictionaryEntry(
      term: 'Trinity',
      language: 'Theological',
      transliteration: 'Trinitas',
      definition: 'One God existing eternally as three distinct persons: Father, Son, and Holy Spirit—equal in deity, distinct in role.',
      usageExample: 'Matthew 28:19 - "...baptizing them in the name of the Father and of the Son and of the Holy Spirit."',
    ),
    'covenant': DictionaryEntry(
      term: 'Covenant',
      language: 'Theological',
      transliteration: 'diatheke (διαθήκη)',
      definition: 'A binding agreement between God and His people. Unlike contracts, covenants are based on relationship and include promises, stipulations, and signs.',
      usageExample: 'Hebrews 8:6 - "But as it is, Christ has obtained a more excellent covenant..."',
    ),
    'gospel': DictionaryEntry(
      term: 'Gospel',
      language: 'Theological',
      transliteration: 'euangelion (εὐαγγέλιον)',
      definition: 'The "good news" that Jesus Christ died for sins, was buried, and rose again, offering forgiveness and eternal life to all who believe.',
      usageExample: '1 Corinthians 15:1-4 - "Now I would remind you of the gospel I preached to you..."',
    ),
  };
}

/// A dictionary entry for a biblical term
class DictionaryEntry {
  final String term;
  final String language;
  final String transliteration;
  final String definition;
  final String? strongsNumber;
  final String? usageExample;
  
  const DictionaryEntry({
    required this.term,
    required this.language,
    required this.transliteration,
    required this.definition,
    this.strongsNumber,
    this.usageExample,
  });
}

/// Riverpod provider for LocalRagDictionary
final localRagDictionaryProvider = Provider<LocalRagDictionary>((ref) {
  return LocalRagDictionary();
});
