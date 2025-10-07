import 'package:flutter/material.dart';
import 'package:my_fitness/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_fitness/APIs/api_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String email = "";
  String avatarUrl = "";
  bool isLoading = true;

  int totalWorkouts = 0;
  int totalMinutes = 0;
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile from backend
  void _loadProfile() async {
    try {
      final profile = await ApiService.getProfile();

      setState(() {
        nameController.text = profile['name'] ?? '';
        bioController.text = profile['bio'] ?? '';
        email = profile['email'] ?? '';
        avatarUrl = profile['avatar'] ?? "";
      });

      final stats = await ApiService.getUserStats(profile['_id']);
      setState(() {
        totalWorkouts = stats['totalWorkouts'] ?? 0;
        totalMinutes = stats['totalMinutes'] ?? 0;
        totalCalories = stats['totalCalories'] ?? 0;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load profile: $e")));
    }
  }

  // Save profile to backend
  void _saveProfile() async {
    try {
      final updated = await ApiService.updateProfile(
        nameController.text,
        bioController.text,
        null, // later pass avatar file path
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
      setState(() {
        nameController.text = updated['name'];
        bioController.text = updated['bio'];
        avatarUrl = updated['avatar'] ?? "";
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  // Logout function
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // clear saved token

    if (!mounted) return; // safety check for async

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Profile picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage("http://10.0.2.2:5000$avatarUrl")
                        : const AssetImage("images/boy.jpeg") as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),

            // Email (read-only)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                email,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),

            // Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: "Bio"),
              ),
            ),

            const SizedBox(height: 30),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat("Workouts", totalWorkouts.toString()),
                _buildStat("Minutes", totalMinutes.toString()),
                _buildStat("Calories", totalCalories.toString()),
              ],
            ),

            const SizedBox(height: 30),

            // Save / Update Profile button
            ElevatedButton.icon(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.save, color: Colors.white, size: 25),
              label: const Text(
                "Save Profile",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Logout
            TextButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}
