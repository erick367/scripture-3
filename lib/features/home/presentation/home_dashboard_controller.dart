import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../journal/data/journal_repository.dart'; // Keep for JournalEntry if needed
import '../../journal/presentation/journal_providers.dart';
import '../../../services/ai_mentor_service.dart';
import '../../bible/presentation/widgets/ai_mentor_panel.dart';
import '../../../core/database/app_database.dart';
import '../application/home_thread_service.dart';
import '../../../services/battery_guard_service.dart';

/// Controller for Home Dashboard specific logic
/// Handles fetching the latest AI-enabled entry and generating the Living Card prompt
/// Now includes battery-aware throttling to conserve power
final homeDashboardControllerProvider = FutureProvider.autoDispose<String?>((ref) async {
  final threadService = ref.watch(homeThreadServiceProvider);
  final batteryGuard = ref.watch(batteryGuardServiceProvider);
  
  // Battery Guardrail: Skip expensive AI call if battery is low
  // In low-power mode, we return a cached/static message instead
  final shouldThrottle = await batteryGuard.shouldThrottle();
  if (shouldThrottle) {
    return "Conserving energy... Check back when charged for personalized insights.";
  }
  
  // 1. Retrieve Trigger Entry
  final targetEntry = await threadService.getTriggerEntry();
  
  if (targetEntry == null) {
    // Safety: New User / No AI Entries
    return "Your journey here is just beginning. Save a reflection to activate personalized follow-ups.";
  }
  
  try {
    // 2. Output Generation (Claude 3.5)
    return await threadService.generateFollowUp(targetEntry);
  } catch (e) {
    // Fallback if AI fails
    return "How is your heart feeling today after your last reflection?";
  }
});

