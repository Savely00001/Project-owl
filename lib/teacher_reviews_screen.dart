import 'package:flutter/material.dart';
import 'review_screen.dart';

class TeacherReviewsScreen extends StatelessWidget {
  final String teacherName;
  final String teacherPosition;
  final String teacherDepartment;

  const TeacherReviewsScreen({
    super.key,
    required this.teacherName,
    required this.teacherPosition,
    required this.teacherDepartment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTeacherInfo(),
                    const SizedBox(height: 20),
                    _buildRatingSection(),
                    const SizedBox(height: 20),
                    _buildReviewsList(),
                    const SizedBox(height: 20),
                    _buildWriteReviewButton(context),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(context, 1),
          ],
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

  Widget _buildTeacherInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 50, color: Color.fromRGBO(224, 167, 87, 1)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacherName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(teacherPosition, style: const TextStyle(fontSize: 14)),
                Text(teacherDepartment, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("4.5", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Row(
            children: List.generate(5, (index) {
              return const Icon(Icons.star, color: Colors.amber, size: 24);
            }),
          ),
          const SizedBox(width: 10),
          const Text("(12 отзывов)", style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    // TODO: Загружать реальные отзывы из базы данных
    final List<Map<String, dynamic>> reviews = [
      {'name': 'Студент 1', 'rating': 5, 'text': 'Отличный преподаватель!', 'date': '2024-03-15'},
      {'name': 'Студент 2', 'rating': 4, 'text': 'Хорошо объясняет материал', 'date': '2024-03-10'},
    ];

    if (reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Column(
          children: [
            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text("Отзывов пока нет", style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text("Вы можете написать первый", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(review['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(review['date'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review['rating'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 5),
              Text(review['text']),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWriteReviewButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewScreen(
              teacherName: teacherName,
              teacherPosition: teacherPosition,
              teacherDepartment: teacherDepartment,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Center(
          child: Text(
            "Написать отзыв",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int selectedIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(199, 199, 199, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          _buildNavButton(context, "Входящие", Icons.sms, 0, selectedIndex),
          _buildNavButton(context, "Преподаватели", Icons.auto_stories, 1, selectedIndex),
          _buildNavButton(context, "Профиль", Icons.person, 2, selectedIndex),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String text, IconData icon, int index, int selectedIndex) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/incoming');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/teachers');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selectedIndex == index ? const Color.fromRGBO(94, 71, 61, 1) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(text, style: const TextStyle(fontSize: 10, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
