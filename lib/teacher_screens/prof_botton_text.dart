import 'package:flutter/material.dart';
import 'teacher_theme.dart';
class ProfBottonText extends StatelessWidget {
  final String text;
  const ProfBottonText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: screenWidth * 0.85,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: TeacherTheme.white,
            width: 1,
          ),
        ),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 13))),
      ),
    );
  }
}
