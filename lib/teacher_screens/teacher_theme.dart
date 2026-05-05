import 'package:flutter/material.dart';

class TeacherTheme {
  // Основные цвета
  static const Color primaryBrown = Color.fromRGBO(94, 71, 61, 1);  // #5E473D
  static const Color lightGray = Color.fromRGBO(227, 227, 227, 1.0);   // #C7C7C7
  static const Color cardBackground = Color.fromRGBO(255, 255, 255, 1); // #FFFFFF
  static const Color goldIcon = Color.fromRGBO(224, 167, 87, 1);    // #E0A757
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black54 = Colors.black54;
  static const Color red = Colors.red;
  static const Color greyShade300 = Color.fromRGBO(225, 225, 225, 1.0); // примерно #E0E0E0
  static const Color greyShade400 = Color.fromRGBO(189, 189, 189, 1);
  static const Color greyShade600 = Color.fromRGBO(117, 117, 117, 1);
  static const Color green = Colors.green;
  static const Color orange = Colors.orange;

  // Текстовые стили
  static const TextStyle headerStyle = TextStyle(fontSize: 24, color: black);
  static const TextStyle subHeaderStyle = TextStyle(fontSize: 14, color: black);
  static const TextStyle titleStyle = TextStyle(fontSize: 32, color: black);
  static const TextStyle bodyTextStyle = TextStyle(fontSize: 14);
  static const TextStyle smallTextStyle = TextStyle(fontSize: 12, color: black54);
  static const TextStyle buttonTextStyle = TextStyle(fontSize: 20, color: white);
  static const TextStyle linkStyle = TextStyle(fontSize: 14, color: primaryBrown);

  // Декорации
  static BoxDecoration searchFieldDecoration(String hintText) {
    return BoxDecoration(
      color: lightGray,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: lightGray),
    );
  }
}