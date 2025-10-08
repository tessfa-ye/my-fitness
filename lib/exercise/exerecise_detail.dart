import 'package:flutter/material.dart';
import 'package:my_fitness/APIs/api_service.dart';
import 'package:my_fitness/services/support_widget.dart';
import 'package:my_fitness/pages/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseDetail extends StatefulWidget {
  final String name;
  final String image;
  final String description;

  const ExerciseDetail({
    super.key,
    required this.name,
    required this.image,
    required this.description,
  });

  @override
  State<ExerciseDetail> createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  int timeInMinutes = 0; // instead of countdown
  int count = 0; // reps
  int set = 0; // sets

  String formatTime(int minutes) {
    final hrs = (minutes ~/ 60).toString().padLeft(2, '0');
    final mins = (minutes % 60).toString().padLeft(2, '0');
    return "$hrs:$mins";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              widget.image,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.8,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(widget.name, style: AppWidget.healineTextStyle(25)),
                  const SizedBox(height: 5),
                  Text(
                    widget.description,
                    style: AppWidget.healineTextStyle(14),
                  ),
                  const SizedBox(height: 50),

                  /// Sets & Reps
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(168, 126, 209, 234),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        /// TIME (Minutes) with Add/Remove
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Workout Time (minutes)",
                                style: AppWidget.healineTextStyle(22),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timeInMinutes++;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add_circle,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    "${timeInMinutes} min",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      if (timeInMinutes > 0) {
                                        setState(() {
                                          timeInMinutes--;
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            // Sets
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Sets",
                                      style: AppWidget.healineTextStyle(22),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              set++;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add_circle,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          set.toString(),
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () {
                                            if (set > 0) {
                                              setState(() {
                                                set--;
                                              });
                                            }
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Reps
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Repetition Count",
                                      style: AppWidget.healineTextStyle(22),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              count++;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add_circle,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          count.toString(),
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () {
                                            if (count > 0) {
                                              setState(() {
                                                count--;
                                              });
                                            }
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Add to Workout Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final exercise = {
                          "name": widget.name,
                          "image": widget.image,
                          "sets": set,
                          "repetitions": count,
                          "timeInMinutes": timeInMinutes,
                        };

                        try {
                          // 1. Get the current workout list
                          final existingWorkouts =
                              await ApiService.getWorkouts();

                          // 2. Check if exercise with same name exists
                          final alreadyExists = existingWorkouts.any(
                            (ex) => ex["exercises"].any(
                              (e) =>
                                  e["name"].toString().toLowerCase() ==
                                  widget.name.toLowerCase(),
                            ),
                          );

                          if (alreadyExists) {
                            // 3️⃣ Show message with option to go to Workout page
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "This exercise is already added. Please delete it before re-adding.",
                                  style: AppWidget.whiteBoldTextStyle(16),
                                ),
                                action: SnackBarAction(
                                  label: "Go to Workout",
                                  textColor: Colors.black,
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final userId =
                                        prefs.getString('userId') ?? "";
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Workout(userId: userId),
                                      ),
                                    );
                                  },
                                ),
                                backgroundColor: const Color.fromARGB(
                                  168,
                                  126,
                                  209,
                                  234,
                                ),
                              ),
                            );
                            return;
                          }

                          // 4. Add new exercise if not duplicate
                          final result = await ApiService.addWorkout(
                            "strength",
                            [exercise],
                          );

                          if (result["error"] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Successfully Added the exercise!",
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to save workout"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },

                      child: const Text(
                        "Add to Workout",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Back Button
            Container(
              margin: const EdgeInsets.only(top: 40, left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
