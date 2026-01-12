import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final batteryGuardServiceProvider = Provider<BatteryGuardService>((ref) {
  return BatteryGuardService();
});

/// Provides battery-aware behavior flags
/// Used to throttle background updates when battery is low
class BatteryGuardService {
  final Battery _battery = Battery();

  /// Check if device is in power-saving conditions
  /// Returns true if battery < 15% OR in battery saver mode
  Future<bool> shouldThrottle() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;
      
      // Throttle if battery is low (< 15%)
      if (batteryLevel < 15) {
        print('🔋 Battery Guard: Low battery detected ($batteryLevel%) - Throttling enabled');
        return true;
      }
      
      // Throttle if battery is discharging and low-ish (< 25%)
      if (batteryState == BatteryState.discharging && batteryLevel < 25) {
         print('🔋 Battery Guard: Discharging at $batteryLevel% - Throttling enabled');
        return true;
      }
      
      // Note: battery_plus doesn't directly expose "Low Power Mode" on iOS
      // but BatteryState.connectedNotCharging can indicate conservation mode
      // UPDATE: Disabling this check as it can false-trigger on some devices
      /*
      if (batteryState == BatteryState.connectedNotCharging) {
        return true;
      }
      */
      
      return false;
    } catch (e) {
      // If we can't read battery, don't throttle
      return false;
    }
  }

  /// Get current battery level percentage
  Future<int> getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      return 100; // Assume full if unavailable
    }
  }

  /// Stream battery state changes
  Stream<BatteryState> get batteryStateStream => _battery.onBatteryStateChanged;
}
