import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_fitness/APIs/api_service.dart';
import 'package:my_fitness/services/support_widget.dart';
import 'package:my_fitness/services/workout_stats_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Workout extends StatefulWidget {
  final Function({int? finished, int? inProgress, double? minutes})?
  onStatsUpdate;
  final String? userId;

  const Workout({super.key, this.onStatsUpdate, this.userId});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String? userId;
  List<dynamic> workouts = [];
  bool isLoading = true;

  Map<String, Timer?> activeTimers = {};

  int prevFinished = 0;
  int prevInProgress = 0;
  double prevMinutes = 0;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _loadUserIdAndWorkouts();
  }

  Future<void> _loadUserIdAndWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Only load from prefs if widget.userId was not passed
      userId ??= prefs.getString('userId');

      // If still null, fetch from API
      if (userId == null || userId!.isEmpty) {
        final profile = await ApiService.getProfile();
        userId = profile['_id']?.toString();

        if (userId == null) {
          debugPrint("⚠️ userId is null from API");
          return;
        }

        await prefs.setString('userId', userId!);
      }

      await fetchWorkouts();

      final stats = await WorkoutStatsStorage.loadStats(userId!);
      setState(() {
        prevFinished = stats['finishedWorkouts'];
        prevInProgress = stats['inProgressWorkouts'];
        prevMinutes = stats['totalMinutes'];

        widget.onStatsUpdate?.call(
          finished: prevFinished,
          inProgress: prevInProgress,
          minutes: prevMinutes,
        );
      });
    } catch (e) {
      debugPrint("❌ Error loading userId or workouts: $e");
    }
  }

  Future<void> fetchWorkouts() async {
    try {
      final data = await ApiService.getWorkouts();
      final savedStates = await WorkoutStatsStorage.loadWorkoutStates(userId!);

      setState(() {
        workouts = data.map((w) {
          w["exercises"] = (w["exercises"] as List).map((ex) {
            final savedEx = savedStates.firstWhere(
              (s) => s["_id"] == ex["_id"] || s["name"] == ex["name"],
              orElse: () => {},
            );

            ex["status"] = savedEx["status"] ?? "not_started";
            ex["elapsedSeconds"] = savedEx["elapsedSeconds"] ?? 0;

            return ex;
          }).toList();
          return w;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Save individual exercise state
  void _saveExerciseState(Map<String, dynamic> exercise) async {
    await WorkoutStatsStorage.saveExerciseState(userId!, exercise);
  }

  void showExerciseTimer(Map<String, dynamic> exercise) {
    final id = exercise["_id"] ?? exercise["name"];
    exercise["status"] ??= "not_started";
    exercise["elapsedSeconds"] ??= 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void startPauseTimer() {
              if (exercise["status"] == "in_progress") {
                activeTimers[id]?.cancel();
                exercise["status"] = "paused";
                _saveExerciseState(exercise);
              } else {
                exercise["status"] = "in_progress";
                activeTimers[id] = Timer.periodic(const Duration(seconds: 1), (
                  timer,
                ) {
                  setStateDialog(() {
                    exercise["elapsedSeconds"]++;
                    if (exercise["elapsedSeconds"] >=
                        (exercise["timeInMinutes"] ?? 0) * 60) {
                      timer.cancel();
                      exercise["status"] = "finished";
                    }
                    _updateStats();
                    _saveExerciseState(exercise); // persist on each tick
                  });
                });
              }
              setStateDialog(() {});
            }

            return AlertDialog(
              title: Text(exercise["name"] ?? "Exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value:
                        ((exercise["elapsedSeconds"] ?? 0) /
                                ((exercise["timeInMinutes"] ?? 0) * 60))
                            .clamp(0.0, 1.0),
                  ),
                  Text(
                    "${exercise["elapsedSeconds"] ?? 0} sec / ${(exercise["timeInMinutes"] ?? 0) * 60} sec",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Stop the timer if active
                          if (exercise["status"] == "in_progress") {
                            activeTimers[id]?.cancel();
                            exercise["status"] =
                                "paused"; // make sure it shows "Start" next time
                            _saveExerciseState(
                              exercise,
                            ); // persist state as paused
                          }

                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),

                      ElevatedButton(
                        onPressed: startPauseTimer,
                        child: Text(
                          exercise["status"] == "in_progress"
                              ? "Pause"
                              : "Start",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Calculate stats only for current workouts in memory
  int _calculateFinished() {
    int count = 0;
    for (var w in workouts) {
      for (var ex in w["exercises"]) {
        if (ex["status"] == "finished") count++;
      }
    }
    return count;
  }

  int _calculateInProgress() {
    int count = 0;
    for (var w in workouts) {
      for (var ex in w["exercises"]) {
        if (ex["status"] == "in_progress") count++;
      }
    }
    return count;
  }

  double _calculateTotalMinutes() {
    double total = 0;
    for (var w in workouts) {
      for (var ex in w["exercises"]) {
        total += (ex["elapsedSeconds"] ?? 0) / 60;
      }
    }
    return total;
  }

  // ✅ Merge current + previous stats and persist
  void _updateStats() {
    final currentFinished = _calculateFinished();
    final currentInProgress = _calculateInProgress();
    final currentMinutes = _calculateTotalMinutes();

    final totalFinished = prevFinished + currentFinished;
    final totalInProgress = prevInProgress + currentInProgress;
    final totalMinutes = prevMinutes + currentMinutes;

    // Update Home screen
    widget.onStatsUpdate?.call(
      finished: totalFinished,
      inProgress: totalInProgress,
      minutes: totalMinutes,
    );

    // Save for persistence
    WorkoutStatsStorage.saveStats(
      userId: userId!,
      finished: totalFinished,
      inProgress: totalInProgress,
      minutes: totalMinutes,
    );
  }

  @override
  void dispose() {
    for (var t in activeTimers.values) {
      t?.cancel();
    }
    super.dispose();
  }

  Future<void> deleteExercise(String workoutId, String exerciseId) async {
    try {
      final token = await ApiService.getToken();
      final response = await http.delete(
        Uri.parse(
          '${ApiService.baseUrl}/workouts/$workoutId/exercises/$exerciseId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          final workoutIndex = workouts.indexWhere(
            (w) => w["_id"] == workoutId,
          );
          if (workoutIndex != -1) {
            workouts[workoutIndex]["exercises"].removeWhere(
              (ex) => ex["_id"].toString() == exerciseId,
            );

            // If no exercises left, remove the workout card
            if (workouts[workoutIndex]["exercises"].isEmpty) {
              workouts.removeAt(workoutIndex);
            }
          }
        });

        // Remove from persistent state
        await WorkoutStatsStorage.removeExerciseState(userId!, exerciseId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exercise deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete exercise: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 231, 193, 42),
        title: Center(
          child: Text("Workouts", style: AppWidget.healineTextStyle(25)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workouts.isEmpty
          ? const Center(child: Text("No workouts yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final w = workouts[index];
                final exercises =
                    (w["exercises"] != null && w["exercises"] is List)
                    ? w["exercises"] as List
                    : [];
                if (exercises.isEmpty) {
                  // Remove workout from UI if no exercises remain
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      workouts.removeAt(index);
                    });
                  });
                  return const SizedBox.shrink(); // empty placeholder
                }

                final firstExercise = exercises[0];

                return GestureDetector(
                  onTap: () {
                    if (firstExercise != null) {
                      showExerciseTimer(firstExercise);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firstExercise?["name"] ?? "Unnamed",
                                    style: AppWidget.healineTextStyle(22),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${firstExercise?["sets"] ?? 0} Sets | ${firstExercise?["repetitions"] ?? 0} Repetitions",
                                    style: const TextStyle(
                                      color: Color.fromARGB(147, 0, 0, 0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffebeafb),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.alarm,
                                          color: Color.fromARGB(
                                            112,
                                            194,
                                            45,
                                            236,
                                          ),
                                          size: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "${(firstExercise?["timeInMinutes"] ?? 0)} min",
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              113,
                                              187,
                                              40,
                                              228,
                                            ),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  final workoutId = w["_id"];
                                  final exerciseId = firstExercise?["_id"]
                                      ?.toString();
                                  if (exerciseId != null) {
                                    deleteExercise(workoutId, exerciseId);
                                  }
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:
                                    firstExercise?["image"] != null &&
                                        firstExercise!["image"]
                                            .toString()
                                            .isNotEmpty
                                    ? Image.asset(
                                        firstExercise["image"],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "images/default.png",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
