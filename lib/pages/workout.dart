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
  Set<String> startedExercises = {}; // for exercises that have been started
  Set<String> finishedExercises = {}; // for exercises that have been completed

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
      _updateStats(); // Recalculate stats from loaded workouts
    } catch (e) {
      debugPrint("❌ Error loading userId or workouts: $e");
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = secs.toString().padLeft(2, '0');
    return "$formattedMinutes:$formattedSeconds";
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

            // Initialize sets based on loaded state
            final id = ex["_id"] ?? ex["name"];
            if (ex["status"] == "in_progress") {
              startedExercises.add(id);
            } else if (ex["status"] == "finished") {
              finishedExercises.add(id);
            }

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
                    // Update stats every second so time spent is accurate
                    _updateStats(syncToBackend: false);

                    if (exercise["elapsedSeconds"] >=
                        (exercise["timeInMinutes"] ?? 0) * 60) {
                      timer.cancel();
                      exercise["status"] = "finished";
                      _updateStats(syncToBackend: true); // Final update
                    }
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
                    "${_formatTime(exercise["elapsedSeconds"] ?? 0)} / "
                    "${_formatTime(((exercise["timeInMinutes"] ?? 0) * 60).toInt())} min",
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
                            _updateStats(syncToBackend: true);
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

  void _updateStats({bool syncToBackend = true}) {
    // Recalculate everything from scratch based on current state
    int finished = 0;
    int inProgress = 0;
    double totalMinutes = 0;

    for (var w in workouts) {
      for (var ex in w["exercises"]) {
        final status = ex["status"];
        if (status == "finished") {
          finished++;
        } else if (status == "in_progress") {
          inProgress++;
        }
        totalMinutes += (ex["elapsedSeconds"] ?? 0) / 60;
      }
    }

    // Update UI
    widget.onStatsUpdate?.call(
      finished: finished,
      inProgress: inProgress,
      minutes: totalMinutes,
    );

    // Save stats persistently
    WorkoutStatsStorage.saveStats(
      userId: userId!,
      finished: finished,
      inProgress: inProgress,
      minutes: totalMinutes,
    );

    // Sync to backend (optional, best effort)
    if (syncToBackend) {
      for (var w in workouts) {
        if (w["_id"] == null) continue;

        // Calculate progress for this specific workout
        int completedSets = 0;
        int totalSets = 0;
        int timeSpentSeconds = 0;
        bool isFinished = true; // assume finished until found otherwise

        for (var ex in w["exercises"]) {
          totalSets += (ex["sets"] as int? ?? 0);
          if (ex["status"] == "finished") {
            completedSets += (ex["sets"] as int? ?? 0);
          } else {
            isFinished = false;
          }
          timeSpentSeconds += (ex["elapsedSeconds"] as int? ?? 0);
        }

        // Only update if there is progress
        if (timeSpentSeconds > 0 || completedSets > 0) {
          ApiService.updateWorkoutProgress(
            workoutId: w["_id"],
            completedSets: completedSets,
            totalSets: totalSets,
            timeSpentSeconds: timeSpentSeconds,
            isFinished: isFinished,
          ).catchError((e) {
            debugPrint("Failed to sync workout ${w["_id"]}: $e");
            return {};
          });
        }
      }
    }
  }

  @override
  void dispose() {
    // Save state of all active timers before disposing
    for (var entry in activeTimers.entries) {
      final id = entry.key;
      final timer = entry.value;

      if (timer != null && timer.isActive) {
        timer.cancel();

        // Find the exercise and update status to paused
        for (var w in workouts) {
          for (var ex in w["exercises"]) {
            final exId = ex["_id"] ?? ex["name"];
            if (exId == id) {
              ex["status"] = "paused";
              _saveExerciseState(ex);
            }
          }
        }
      }
    }

    // Final stats update
    _updateStats(syncToBackend: true);

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
        if (mounted) {
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
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to delete exercise: ${response.body}"),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
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
