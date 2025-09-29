import 'package:flutter/material.dart';
import 'package:my_fitness/pages/login.dart';
import 'package:my_fitness/services/support_widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              child: Image.asset("images/f.png", height: 500),
            ),
            const SizedBox(height: 10),

            // Title text
            const Text(
              "Welcome to FitLife",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Subtitle text
            Center(
              child: const Text(
                "Track your workouts, stay motivated, and reach your goals!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 130),

            // Get Started Button
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 60, right: 60),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => Login()),
                  ),
                  child: Text(
                    "Get Started",
                    style: AppWidget.whiteBoldTextStyle(23),
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
