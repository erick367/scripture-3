import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/bible_verse.dart';

class InsightTriggerWidget extends StatelessWidget {
  final InsightKeyword keyword;
  final VoidCallback onTap;

  const InsightTriggerWidget({
    super.key,
    required this.keyword,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Icon(
          LucideIcons.search,
          size: 16,
          color: Colors.blueGrey, // Subtle, as per clean initial view
        ),
      ),
    );
  }
}
