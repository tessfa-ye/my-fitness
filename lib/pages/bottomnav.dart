import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_fitness/pages/home.dart';
import 'package:my_fitness/pages/profile.dart';
import 'package:my_fitness/pages/workout.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTabIndex = 0;
  late List<Widget> pages;

  final GlobalKey<HomeState> homeKey = GlobalKey<HomeState>(); // ✅ Key for Home

  late Home home;
  late Workout workout;
  late Profile profile;

  @override
  void initState() {
    home = Home(key: homeKey);
    workout = Workout();
    profile = Profile();
    pages = [home, workout, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 231, 193, 42),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) async {
          setState(() {
            currentTabIndex = index;
          });

          // ✅ When switching to Home tab, refresh stats
          if (index == 0) {
            await homeKey.currentState?.refreshStats();
          }
        },
        items: const [
          Icon(Icons.home, color: Colors.black, size: 30),
          Icon(Icons.run_circle, color: Colors.black, size: 30),
          Icon(Icons.person, color: Colors.black, size: 30),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
