import 'package:flutter/material.dart';
import 'package:flutter_application_1/entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,   // белый фон для всех Scaffold
        canvasColor: Colors.white,               // белый фон для BottomSheet
        primaryColor: const Color.fromRGBO(94, 71, 61, 1),
      ),
      title: "Филин",
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset('assets/Logo.png', width: 60, height: 60),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Филин", style: TextStyle(fontSize: 24)),
                          const Text(
                            "Проект по поиску помощи в проектах",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Добро пожаловать!",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              MyBotton(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBotton extends StatelessWidget {
  const MyBotton({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Entry()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
        width: screenWidth * 0.85,
        height: 70,
        decoration: BoxDecoration(
          color: Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Center(
          child: Text(
            "Начать",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
