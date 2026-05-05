import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Поиск...',
              filled: true,
              fillColor: Color.fromRGBO(227, 227, 227, 1.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(227, 227, 227, 1.0),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Blocks(
          text: "Иванов Иван",
          text_1: "Информационные технологии",
          text_2: "Ученая степень: Доцент",
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
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
        border: Border.all(width: 1, color: Color.fromRGBO(227, 227, 227, 1.0)),
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
