import 'package:flutter/material.dart';
import 'package:my_fitness/APIs/api_service.dart';
import 'package:my_fitness/exercise/stretching_page.dart';
import 'package:my_fitness/exercise/cardio_page.dart';
import 'package:my_fitness/exercise/arm_page.dart';
import 'package:my_fitness/pages/workout.dart';
import 'package:my_fitness/services/support_widget.dart';
import 'package:my_fitness/services/workout_stats_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  String userId = "";
  String userName = "";
  String avatarUrl = "";

  int totalWorkouts = 0;
  int inProgressWorkouts = 0;
  double totalMinutes = 0;
  List<dynamic> topWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  String _formatTimeSpent(double totalMinutes) {
    int totalSeconds = (totalMinutes * 60).toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String h = hours.toString().padLeft(2, '0');
    String m = minutes.toString().padLeft(2, '0');
    String s = seconds.toString().padLeft(2, '0');

    return "$h:$m:$s";
  }

  Future<void> refreshStats() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (userId.isEmpty) {
      print("⚠️ No userId found");
      return;
    }
    final stats = await WorkoutStatsStorage.loadStats(userId);
    setState(() {
      totalWorkouts = stats['finishedWorkouts'];
      inProgressWorkouts = stats['inProgressWorkouts'];
      totalMinutes = stats['totalMinutes'];
    });
  }

  void _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to load from cache first
      String? storedName = prefs.getString('userName');
      String? storedAvatar = prefs.getString('avatar');
      String? userId = prefs.getString('userId');

      if (userId == null) {
        // Fallback: fetch from API if not stored yet
        final profile = await ApiService.getProfile();
        userId = profile['_id'];
        storedName = profile['name'] ?? "User";
        storedAvatar = profile['avatar'] ?? "";

        // Save for next time
        await prefs.setString('userId', userId!);
        await prefs.setString('userName', storedName!);
        await prefs.setString('avatar', storedAvatar!);
      }

      setState(() {
        this.userId = userId!;
        userName = storedName ?? "User";
        avatarUrl = storedAvatar ?? "";
      });

      // ✅ Load user stats from API
      if (userId != null) {
        final stats = await ApiService.getUserStats(userId!);
        setState(() {
          totalWorkouts = stats['finished'] ?? 0;
          inProgressWorkouts = stats['inProgress'] ?? 0;
          totalMinutes = (stats['totalTimeSeconds'] ?? 0) / 60;
        });
      }
    } catch (e) {
      print("⚠️ Error loading user data: $e");
    }
  }

  void updateWorkoutStats({int? finished, int? inProgress, double? minutes}) {
    setState(() {
      if (finished != null) totalWorkouts = finished;
      if (inProgress != null) inProgressWorkouts = inProgress;
      if (minutes != null) totalMinutes = minutes;
    });
  }

  void _openWorkoutPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            Workout(onStatsUpdate: updateWorkoutStats, userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 45, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //column 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $userName",
                        style: AppWidget.healineTextStyle(24),
                      ),
                      Text(
                        "Let's check your activity",
                        style: AppWidget.mediumTextStyle(18),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "images/boy.jpeg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // column 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "🎖️ Finished",
                            style: AppWidget.mediumTextStyle(18),
                          ),
                          SizedBox(height: 20),
                          Text(
                            totalWorkouts.toString(),
                            style: AppWidget.healineTextStyle(40),
                          ),
                          Text(
                            "Completed Workouts",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(147, 0, 0, 0),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "🔄 In Progress",
                                style: AppWidget.mediumTextStyle(20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    inProgressWorkouts.toString(),
                                    style: AppWidget.healineTextStyle(24),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Workouts",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromARGB(147, 0, 0, 0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "🕒 Time Spent",
                                style: AppWidget.mediumTextStyle(20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatTimeSpent(totalMinutes),
                                    style: AppWidget.healineTextStyle(24),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "hr",
                                    textAlign: TextAlign.center,
                                    style: AppWidget.healineTextStyle(24),
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
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getString('userId');

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User not found. Please log in again."),
                        ),
                      );
                      return;
                    }

                    await WorkoutStatsStorage.clearStats(userId);

                    setState(() {
                      totalWorkouts = 0;
                      inProgressWorkouts = 0;
                      totalMinutes = 0;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Daily activity stats cleared!"),
                      ),
                    );
                  },

                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text(
                    "Reset Progress",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              //column 3
              SizedBox(height: 30),
              Text(
                "Discover New Workouts",
                style: AppWidget.healineTextStyle(20),
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CardioPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xff57949e),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cardio",
                                      style: AppWidget.whiteBoldTextStyle(28),
                                    ),
                                    Text(
                                      "5 Exercises",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "25 Minutes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset("images/cardio.png"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArmPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(181, 89, 155, 241),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Arm",
                                      style: AppWidget.whiteBoldTextStyle(28),
                                    ),
                                    Text(
                                      "10 Exercises",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "40 Minutes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset("images/arm.png"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StretchingPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 64, 198, 255),

                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stretching",
                                      style: AppWidget.whiteBoldTextStyle(28),
                                    ),
                                    Text(
                                      "10 Exercises",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "40 Minutes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset("images/stretching.png"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // column 4,5,6....
              Text("Top Workouts", style: AppWidget.healineTextStyle(20)),
              SizedBox(height: 20),
              ...topWorkouts.map((workout) {
                return Container(
                  margin: EdgeInsets.only(right: 50, left: 10, bottom: 20),
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.only(left: 30, top: 10, bottom: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout["name"] ?? "Unknown",
                                style: AppWidget.healineTextStyle(22),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${workout["sets"] ?? 0} Sets | ${workout["repetitions"] ?? 0} Repetitions",
                                style: TextStyle(
                                  color: Color.fromARGB(147, 0, 0, 0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 5),

                              Container(
                                padding: EdgeInsets.all(5),
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xffebeafb),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      color: const Color.fromARGB(
                                        112,
                                        194,
                                        45,
                                        236,
                                      ),
                                      size: 25,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${workout["timeInMinutes"] ?? 0}:00",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
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
                          SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                workout["image"] != null &&
                                    workout["image"].toString().isNotEmpty
                                ? Image.asset(
                                    workout["image"],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 100,
                                        color: Colors.grey[200],
                                        child: Icon(Icons.fitness_center),
                                      );
                                    },
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.fitness_center),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
