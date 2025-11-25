import 'package:flutter/material.dart';
import 'package:my_fitness/exercise/exerecise_detail.dart';

class StretchingPage extends StatelessWidget {
  final List<Map<String, String>> stretchingExercises = [
    {
      "name": "Calf Stretch",
      "image": "images/calfstretch.png",
      "duration": "2 min",
      "description":
          "A calf stretch helps lengthen the muscles in the lower leg, improving ankle mobility and reducing pain.",
    },
    {
      "name": "Hamstring Stretch",
      "image": "images/hamstring.png",
      "duration": "3 min",
      "description":
          "Hamstring stretches loosen the muscles in the back of your thigh and improve flexibility.",
    },
    {
      "name": "Shoulder Stretch",
      "image": "images/shoulder.png",
      "duration": "2 min",
      "description":
          "Shoulder stretches improve flexibility and relieve tension in the upper body.",
    },
    {
      "name": "Quad Stretch",
      "image": "images/quadstretch.png",
      "duration": "2 min",
      "description":
          "A quad stretch targets the front thigh muscles, improving mobility and reducing injury risk.",
    },
    {
      "name": "Cat Cow",
      "image": "images/catcow.png",
      "duration": "2 min",
      "description":
          "A gentle yoga flow between arching and rounding your back. Improves spine flexibility and warms up core muscles.",
    },
    {
      "name": "Chest Opener",
      "image": "images/chestopner.png",
      "duration": "2 min",
      "description":
          "Opens up the chest and improves posture, especially helpful after sitting long hours.",
    },
    {
      "name": "Neck Stretch",
      "image": "images/neck.png",
      "duration": "1 min",
      "description":
          "Relieves tension in the neck muscles, reducing stress and stiffness.",
    },
    {
      "name": "Hip Flexor Stretch",
      "image": "images/hip.png",
      "duration": "3 min",
      "description":
          "Targets the hip flexors, improving mobility and reducing tightness from sitting.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stretching Exercises"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: stretchingExercises.length,
        itemBuilder: (context, index) {
          final exercise = stretchingExercises[index];
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
