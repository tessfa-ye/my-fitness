import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_fitness/pages/login.dart';
import 'package:my_fitness/pages/bottomnav.dart';
import 'package:my_fitness/services/support_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _checkingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // user is logged in → go to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Bottomnav()),
      );
    } else {
      // no token → stay here
      setState(() => _checkingLogin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLogin) {
      // Show splash loader while checking
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("images/f.png", height: 500),
            const SizedBox(height: 10),

            const Text(
              "Welcome to FitLife",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                "Track your workouts, stay motivated, and reach your goals!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 130),

            // Get Started Button
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 60, right: 60),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => const Login()),
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
