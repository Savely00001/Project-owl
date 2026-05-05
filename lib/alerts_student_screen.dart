import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  const Alert({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Text("Уведомлений нет", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
