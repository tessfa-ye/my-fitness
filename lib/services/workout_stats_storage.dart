import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutStatsStorage {
  static String _finishedKey(String userId) => '${userId}_finishedWorkouts';
  static String _inProgressKey(String userId) => '${userId}_inProgressWorkouts';
  static String _minutesKey(String userId) => '${userId}_totalMinutes';
  static String _exerciseStatesKey(String userId) => '${userId}_exerciseStates';

  // Save user-specific stats
  static Future<void> saveStats({
    required String userId,
    required int finished,
    required int inProgress,
    required double minutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_finishedKey(userId), finished);
    await prefs.setInt(_inProgressKey(userId), inProgress);
    await prefs.setDouble(_minutesKey(userId), minutes);
  }

  // Load user-specific stats
  static Future<Map<String, dynamic>> loadStats(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'finishedWorkouts': prefs.getInt(_finishedKey(userId)) ?? 0,
      'inProgressWorkouts': prefs.getInt(_inProgressKey(userId)) ?? 0,
      'totalMinutes': prefs.getDouble(_minutesKey(userId)) ?? 0.0,
    };
  }

  // Clear only current user’s stats
  static Future<void> clearStats(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_finishedKey(userId));
    await prefs.remove(_inProgressKey(userId));
    await prefs.remove(_minutesKey(userId));
  }

  // Save exercise progress per user
  static Future<void> saveExerciseState(
    String userId,
    Map<String, dynamic> exercise,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(_exerciseStatesKey(userId)) ?? [];

    saved.removeWhere(
      (e) => Map<String, dynamic>.from(jsonDecode(e))["_id"] == exercise["_id"],
    );

    saved.add(jsonEncode(exercise));
    await prefs.setStringList(_exerciseStatesKey(userId), saved);
  }

  // Load exercise states per user
  static Future<List<Map<String, dynamic>>> loadWorkoutStates(
    String userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_exerciseStatesKey(userId)) ?? [];
    return saved.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // Remove one exercise for that user
  static Future<void> removeExerciseState(String userId, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> states =
        prefs.getStringList(_exerciseStatesKey(userId)) ?? [];
    final List<Map<String, dynamic>> decoded = states
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList();

    decoded.removeWhere((s) => s["_id"].toString() == id || s["name"] == id);

    final List<String> encoded = decoded.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList(_exerciseStatesKey(userId), encoded);
  }
}
