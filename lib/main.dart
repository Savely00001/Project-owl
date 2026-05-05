import 'package:flutter/material.dart';
import 'package:flutter_application_1/entry.dart';
import 'package:flutter_application_1/profile_student.dart';
import 'package:flutter_application_1/teachers_screen_student_has.dart';
import 'package:flutter_application_1/incoming_screen_student_has.dart';
import 'package:flutter_application_1/edit_profile_screen.dart';
import 'package:flutter_application_1/teacher_reviews_screen.dart';
import 'package:flutter_application_1/review_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Филин",
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const Entry(),
        '/profile': (context) => const ProfileStudent(),
        '/teachers': (context) => const Teachers(),
        '/incoming': (context) => const Incoming(),
        '/edit_profile': (context) => const EditProfileScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 50),
          ],
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
          MaterialPageRoute(builder: (context) => const Entry()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
        width: screenWidth * 0.85,
        height: 70,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(94, 71, 61, 1),
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