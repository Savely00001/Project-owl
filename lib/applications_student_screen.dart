import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40, left: 30),
          child: Container(
            width: screenWidth * 0.85,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(218, 218, 218, 1),
            ),
            child: Text(
              "Фильтры:",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30),
          child: Blocks(
            text: "Иванов Иван",
            text_1: "Информационные технологии",
            text_2: "Ученая степень: Доцент",
          ),
        ),
      ],
    );
  }
}

class Blocks extends StatelessWidget {
  final String text;
  final String text_1;
  final String text_2;
  const Blocks({
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
        color: const Color.fromRGBO(218, 218, 218, 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_circle,
            size: 42,
            color: Color.fromRGBO(224, 167, 87, 1),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: TextStyle(fontSize: 14)),
              Text(text_1, style: TextStyle(fontSize: 14)),
              Text(text_2, style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
