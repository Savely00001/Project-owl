import 'package:flutter/material.dart';
import 'teacher_theme.dart';

class ProfBottonText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const ProfBottonText({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.85,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color.fromRGBO(199, 199, 199, 1),
            width: 1,
          ),
        ),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 13))),
      ),
    );
  }
}
