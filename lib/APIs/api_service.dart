import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      // 'http://10.0.2.2:5000/api'; // use localhost for emulator
      'http://192.168.137.1:5000/api'; // use localhost for android device

  // Save token locally
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Signup
  static Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) await saveToken(data['token']);
    return data;
  }

  // Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) await saveToken(data['token']);
    return data;
  }

  // Get Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Update Profile (with avatar)
  static Future<Map<String, dynamic>> updateProfile(
    String name,
    String bio,
    String? avatarPath,
  ) async {
    final token = await getToken();
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/profile'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['bio'] = bio;
    if (avatarPath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatarPath),
      );
    }
    var res = await request.send();
    final response = await http.Response.fromStream(res);
    return jsonDecode(response.body);
  }

  // Add Workout
  static Future<Map<String, dynamic>> addWorkout(
    String type,
    List<Map<String, dynamic>> exercises,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/workouts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'type': type, 'exercises': exercises}),
    );
    return jsonDecode(response.body);
  }

  // get Workout
  static Future<List<dynamic>> getWorkouts() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/workouts'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Get Stats
  static Future<Map<String, dynamic>> getUserStats(String userId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/workouts/stats/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Finish Workout
  static Future<Map<String, dynamic>> finishWorkout(String workoutId) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/workouts/$workoutId/finish'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // Update workout progress
  static Future<Map<String, dynamic>> updateWorkoutProgress({
    required String workoutId,
    required int completedSets,
    required int totalSets,
    required int timeSpentSeconds,
    required bool isFinished,
  }) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/workouts/$workoutId/progress'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'completedSets': completedSets,
        'totalSets': totalSets,
        'timeSpentSeconds': timeSpentSeconds,
        'isFinished': isFinished,
      }),
    );
    return jsonDecode(response.body);
  }
}
