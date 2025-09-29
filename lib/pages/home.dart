import 'package:flutter/material.dart';
import 'package:my_fitness/services/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 45, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(),
              //column 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, Tess", style: AppWidget.healineTextStyle(24)),
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
                          Text("6", style: AppWidget.healineTextStyle(40)),
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
                                    "2",
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
                                    "0.0",
                                    style: AppWidget.healineTextStyle(24),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Minutes",
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
                    ],
                  ),
                ],
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
                    Container(
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
                    SizedBox(width: 20),
                    Container(
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
                    SizedBox(width: 20),
                    Container(
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
                    SizedBox(width: 50),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // column 4,5,6....
              Text("Top Workouts", style: AppWidget.healineTextStyle(20)),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(right: 50, left: 10),
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
                              "Squats",
                              style: AppWidget.healineTextStyle(22),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "3 Sets | 10 Repetitions",
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
                                    "10:00",
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
                        Image.asset(
                          "images/squat.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(right: 50, left: 10),
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
                              "Pushups",
                              style: AppWidget.healineTextStyle(22),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "2 Sets | 20 Repetitions",
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
                                    "20:00",
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
                        Image.asset(
                          "images/pushup.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(right: 50, left: 10),
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
                              "Situps",
                              style: AppWidget.healineTextStyle(22),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "1 Sets | 10 Repetitions",
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
                                    "5:00",
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
                        Image.asset(
                          "images/situp.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
