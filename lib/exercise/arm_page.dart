import 'package:flutter/material.dart';
import 'package:my_fitness/exercise/exerecise_detail.dart';

class ArmPage extends StatelessWidget {
  final List<Map<String, String>> armExercises = [
    {
      "name": "Bicep Curls",
      "image": "images/bicep_curls.png",
      "duration": "10 min",
      "description":
          "Isolates the biceps to build arm strength and definition.",
    },
    {
      "name": "Tricep Dips",
      "image": "images/tricep_dips.png",
      "duration": "10 min",
      "description":
          "Targets the triceps using body weight for resistance.",
    },
    {
      "name": "Pushups",
      "image": "images/pushup.png",
      "duration": "10 min",
      "description":
          "A compound exercise that works the chest, shoulders, and triceps.",
    },
    {
      "name": "Hammer Curls",
      "image": "images/hammer_curls.png",
      "duration": "10 min",
      "description":
          "Targets the biceps and forearms for overall arm development.",
    },
    {
      "name": "Overhead Press",
      "image": "images/overhead_press.png",
      "duration": "10 min",
      "description":
          "Builds shoulder and tricep strength with overhead movement.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arm Exercises"),
        backgroundColor: const Color.fromARGB(181, 89, 155, 241),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: armExercises.length,
        itemBuilder: (context, index) {
          final exercise = armExercises[index];
          return Card(
            margin: EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  exercise["image"]!,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fitness_center, size: 40),
                ),
              ),
              title: Text(
                exercise["name"]!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text("Duration: ${exercise["duration"]}"),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetail(
                      name: exercise['name']!,
                      image: exercise['image']!,
                      description: exercise['description']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
