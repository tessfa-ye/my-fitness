import 'package:flutter/material.dart';

class Workout extends StatelessWidget {
  const Workout({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = [
      {"title": "Cardio", "image": "images/cardio.png", "time": "25 min"},
      {"title": "Strength", "image": "images/arm.png", "time": "40 min"},
      {"title": "Yoga", "image": "images/stretching.png", "time": "30 min"},
      {"title": "HIIT", "image": "images/squat.png", "time": "20 min"},
    ];

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Image.asset(workout["image"]!, height: 60, width: 60),
                title: Text(
                  workout["title"]!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Duration: ${workout["time"]}",
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Start"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
