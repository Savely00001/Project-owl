import 'package:flutter/material.dart';
import 'teacher_theme.dart';
class ProfButtonMain extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool hasBack;
  final bool hasColor;
  final VoidCallback? onTap;
  const ProfButtonMain({
    super.key,
    required this.text,
    required this.icon,
    required this.hasBack,
    required this.hasColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: hasBack ? TeacherTheme.primaryBrown : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: hasColor
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 0, 0, 0),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: hasColor
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}