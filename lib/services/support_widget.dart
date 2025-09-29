import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle healineTextStyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle mediumTextStyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle whiteBoldTextStyle(double size) {
    return TextStyle(
      color: Colors.white,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }
}
