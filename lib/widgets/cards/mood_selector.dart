import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Mood Selector Widget
/// 
/// 5 emoji buttons with gradient selection
class MoodSelector extends StatelessWidget {
  final int? selectedMood;
  final Function(int) onMoodSelected;
  final bool isDark;

  const MoodSelector({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
    this.isDark = true,
  });

  static const List<_Mood> moods = [
    _Mood(
      emoji: '😞',
      label: 'Struggling',
      gradient: AppColors.moodStruggling,
    ),
    _Mood(
      emoji: '😐',
      label: 'Neutral',
      gradient: LinearGradient(
        colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)],
      ),
    ),
    _Mood(
      emoji: '🙂',
      label: 'Good',
      gradient: AppColors.moodGood,
    ),
    _Mood(
      emoji: '😊',
      label: 'Blessed',
      gradient: AppColors.moodBlessed,
    ),
    _Mood(
      emoji: '🤩',
      label: 'Overflowing',
      gradient: AppColors.moodOverflowing,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(moods.length, (index) {
        final mood = moods[index];
        final isSelected = selectedMood == index;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onMoodSelected(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isSelected ? mood.gradient : null,
                    color: !isSelected
                        ? (isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey[100])
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      mood.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mood.label,
                  style: AppTextStyles.caption(
                    color: isDark
                        ? Colors.white.withOpacity(isSelected ? 1.0 : 0.6)
                        : isSelected
                            ? Colors.grey[900]
                            : Colors.grey[600],
                  ).copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Mood {
  final String emoji;
  final String label;
  final LinearGradient gradient;

  const _Mood({
    required this.emoji,
    required this.label,
    required this.gradient,
  });
}
