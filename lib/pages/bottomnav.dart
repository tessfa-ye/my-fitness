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

  late Widget currentPage;
  late Home home;
  late Workout workout;
  late Profile profile;

  @override
  void initState() {
    home = Home();
    workout = Workout();
    profile = Profile();
    pages = [home, workout, profile];
    currentPage = Home();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 231, 193, 42),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home, color: Colors.black, size: 30),
          Icon(Icons.run_circle, color: Colors.black, size: 30),
          Icon(Icons.person, color: Colors.black, size: 30),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
