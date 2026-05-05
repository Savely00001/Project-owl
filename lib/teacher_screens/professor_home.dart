import 'package:flutter/material.dart';
import 'prof_button_main.dart';
import 'screen_professor.dart';
import 'students_screen.dart';
import 'professor_profile_screen.dart';
import 'teacher_theme.dart';
class ProfessorHome extends StatefulWidget {
  const ProfessorHome({super.key});

  @override
  State<ProfessorHome> createState() => _ProfessorHomeState();
}

class _ProfessorHomeState extends State<ProfessorHome> {
  int _currentIndex = 0;

  //
  final List<Widget> _screens = [
    const ScreenProfessor(),
    const StudentsScreen(),
    const ProfessorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(index: _currentIndex, children: _screens),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: TeacherTheme.lightGray,   // C7C7C7
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ProfButtonMain(
                      text: "Входящие",
                      icon: Icons.sms,
                      hasBack: _currentIndex == 0,
                      hasColor: _currentIndex == 0,
                      onTap: () => setState(() => _currentIndex = 0),
                    ),
                  ),
                  Expanded(
                    child: ProfButtonMain(
                      text: "Студенты",
                      icon: Icons.people,
                      hasBack: _currentIndex == 1,
                      hasColor: _currentIndex == 1,
                      onTap: () => setState(() => _currentIndex = 1),
                    ),
                  ),
                  Expanded(
                    child: ProfButtonMain(
                      text: "Профиль",
                      icon: Icons.person,
                      hasBack: _currentIndex == 2,
                      hasColor: _currentIndex == 2,
                      onTap: () => setState(() => _currentIndex = 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}