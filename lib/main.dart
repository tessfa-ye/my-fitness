import 'package:flutter/material.dart';
import 'package:my_fitness/pages/bottomnav.dart';
import 'package:my_fitness/pages/home.dart';
import 'package:my_fitness/pages/landing_page.dart';
import 'package:my_fitness/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LandingPage(),
    );
  }
}
