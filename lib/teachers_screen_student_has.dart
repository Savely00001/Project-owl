import 'package:flutter/material.dart';
import 'teacher_reviews_screen.dart';

class Teachers extends StatelessWidget {
  const Teachers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Преподавательский состав",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const Botton(),
              const SizedBox(height: 20),
              // Список преподавателей
              TeacherCard(
                name: "Иванов Иван Иванович",
                position: "Доцент",
                department: "Информационные технологии",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherReviewsScreen(
                        teacherName: "Иванов Иван Иванович",
                        teacherPosition: "Доцент",
                        teacherDepartment: "Информационные технологии",
                      ),
                    ),
                  );
                },
              ),
              TeacherCard(
                name: "Сергеев Сергей Сергеевич",
                position: "Доктор наук",
                department: "Информационные технологии",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherReviewsScreen(
                        teacherName: "Сергеев Сергей Сергеевич",
                        teacherPosition: "Доктор наук",
                        teacherDepartment: "Информационные технологии",
                      ),
                    ),
                  );
                },
              ),
              TeacherCard(
                name: "Валуева Валерия Викторовна",
                position: "Кандидат наук",
                department: "Информационные технологии",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherReviewsScreen(
                        teacherName: "Валуева Валерия Викторовна",
                        teacherPosition: "Кандидат наук",
                        teacherDepartment: "Информационные технологии",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.asset('assets/Logo.png', width: 60, height: 60),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Филин", style: TextStyle(fontSize: 24)),
                Text("Проект по поиску помощи в проектах", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String position;
  final String department;
  final VoidCallback onTap;

  const TeacherCard({
    super.key,
    required this.name,
    required this.position,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: const Color.fromRGBO(218, 218, 218, 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_circle, size: 50, color: Color.fromRGBO(224, 167, 87, 1)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(department, style: const TextStyle(fontSize: 14)),
                  Text(position, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class Botton extends StatelessWidget {
  const Botton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 13),
        width: screenWidth * 0.85,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Center(
          child: Text(
            "🔍 Нажмите, для настройки поиска",
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
