import 'package:shared_preferences/shared_preferences.dart';

class WorkoutStatsStorage {
  static const _finishedKey = 'finishedWorkouts';
  static const _inProgressKey = 'inProgressWorkouts';
  static const _minutesKey = 'totalMinutes';

  static Future<void> saveStats({
    required int finished,
    required int inProgress,
    required double minutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_finishedKey, finished);
    await prefs.setInt(_inProgressKey, inProgress);
    await prefs.setDouble(_minutesKey, minutes);
  }

  static Future<Map<String, dynamic>> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'finishedWorkouts': prefs.getInt(_finishedKey) ?? 0,
      'inProgressWorkouts': prefs.getInt(_inProgressKey) ?? 0,
      'totalMinutes': prefs.getDouble(_minutesKey) ?? 0.0,
    };
  }

  static Future<void> clearStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_finishedKey);
    await prefs.remove(_inProgressKey);
    await prefs.remove(_minutesKey);
  }
}
