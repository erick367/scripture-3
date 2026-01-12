import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/emotion_tags.dart';

/// Reusable emotion chip widget with glassmorphic styling
class EmotionChip extends StatelessWidget {
  final EmotionTag tag;
  final bool isSelected;
  final VoidCallback onTap;

  const EmotionChip({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? tag.color.withValues(alpha: 0.25)
              : Colors.transparent,
          border: Border.all(
            color: tag.color.withValues(alpha: isSelected ? 0.8 : 0.4),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tag.icon, size: 16, color: tag.color),
            const SizedBox(width: 6),
            Text(
              tag.label,
              style: GoogleFonts.inter(
                color: tag.color,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable emotion picker
class EmotionPicker extends StatelessWidget {
  final EmotionTag? selectedEmotion;
  final Function(EmotionTag) onEmotionSelected;

  const EmotionPicker({
    super.key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: EmotionTag.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final emotion = EmotionTag.values[index];
          return EmotionChip(
            tag: emotion,
            isSelected: selectedEmotion == emotion,
            onTap: () => onEmotionSelected(emotion),
          );
        },
      ),
    );
  }
}
