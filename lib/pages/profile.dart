import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("images/boy.jpeg"),
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
            const Text(
              "Tess Woretaw",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "tessfayye@gmail.com",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Fitness enthusiast 💪 | Consistency is key | Push harder every day!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat("Workouts", "25"),
                _buildStat("Minutes", "540"),
                _buildStat("Calories", "1200"),
              ],
            ),
            const SizedBox(height: 30),
            // Edit Profile button
            ElevatedButton.icon(
              onPressed: () {},
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
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            // Logout
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontSize: 18),
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
