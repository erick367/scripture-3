class VerseInsight {
  final String naturalMeaning;
  final String originalContext;
  final String soWhat;
  final String scenario;
  final List<String> threads;

  const VerseInsight({
    required this.naturalMeaning,
    required this.originalContext,
    required this.soWhat,
    required this.scenario,
    required this.threads,
  });

  factory VerseInsight.fromJson(Map<String, dynamic> json) {
    return VerseInsight(
      naturalMeaning: json['naturalMeaning'] as String,
      originalContext: json['originalContext'] as String,
      soWhat: json['soWhat'] as String,
      scenario: json['scenario'] as String,
      threads: (json['threads'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'naturalMeaning': naturalMeaning,
      'originalContext': originalContext,
      'soWhat': soWhat,
      'scenario': scenario,
      'threads': threads,
    };
  }
}
