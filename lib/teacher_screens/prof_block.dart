import 'package:flutter/material.dart';
import 'teacher_theme.dart';

class ProfBlock extends StatelessWidget {
  final String text;
  final String text_1;
  final String text_2;
  const ProfBlock({
    super.key,
    required this.text,
    required this.text_1,
    required this.text_2,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.85,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: TeacherTheme.white,                // чисто белый фон
        border: Border.all(
          color: TeacherTheme.lightGray,           // граница #C7C7C7
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_circle,
            size: 42,
            color: TeacherTheme.goldIcon,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: const TextStyle(fontSize: 14)),
              Text(text_1, style: const TextStyle(fontSize: 14)),
              Text(text_2, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}