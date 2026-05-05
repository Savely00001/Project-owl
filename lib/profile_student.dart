import 'package:flutter/material.dart';
import 'package:flutter_application_1/teachers_screen_student_has.dart';
import 'package:flutter_application_1/incoming_screen_student_has.dart';
import 'package:flutter_application_1/user_data.dart';
import 'package:flutter_application_1/edit_profile_screen.dart';

class ProfileStudent extends StatefulWidget {
  const ProfileStudent({super.key});

  @override
  State<ProfileStudent> createState() => _ProfileStudent();
}

class _ProfileStudent extends State<ProfileStudent> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    const Incoming(),
    const Teachers(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
            _buildBottomNavBar(context, _selectedIndex),
          ],
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
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(context, "Входящие", Icons.sms, 0, selectedIndex),
          _buildNavButton(
            context,
            "Преподаватели",
            Icons.auto_stories,
            1,
            selectedIndex,
          ),
          _buildNavButton(context, "Профиль", Icons.person, 2, selectedIndex),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String text,
    IconData icon,
    int index,
    int selectedIndex,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? const Color.fromRGBO(94, 71, 61, 1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selectedIndex == index ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Экран "Профиль студента"
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = UserData.name;
  String _group = UserData.group;
  String _department = UserData.department;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _name = UserData.name;
      _group = UserData.group;
      _department = UserData.department;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Мой профиль", style: TextStyle(fontSize: 32)),
            ),
          ),
          // Карточка с данными пользователя
          Container(
            width: screenWidth * 0.85,
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: const Color.fromRGBO(199, 199, 199, 1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 42,
                  color: Color.fromRGBO(224, 167, 87, 1),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name.isEmpty ? "Не указано" : _name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _group.isEmpty ? "Группа не указана" : _group,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        _department.isEmpty
                            ? "Кафедра не указана"
                            : _department,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Кнопка редактирования профиля
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
                if (result == true) {
                  setState(() {
                    _name = UserData.name;
                    _group = UserData.group;
                    _department = UserData.department;
                  });
                }
              },
              child: Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(94, 71, 61, 1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Color.fromRGBO(224, 167, 87, 1)),
                    SizedBox(width: 10),
                    Text(
                      "Редактировать профиль",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Выбранное направление ВКР
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Выбранное направление ВКР/Проекта:",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BottonText(text: "Нажмите, чтобы начать ввод"),
          ),
          // Оставить отзыв
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Оставить отзыв на преподавателя:",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BottonText(
              text: "Нажмите, чтобы выбрать из списка",
              onTap: () {
                // Переключаем нижнюю панель на преподавателей
                final profileStudentState = context
                    .findAncestorStateOfType<_ProfileStudent>();
                if (profileStudentState != null) {
                  profileStudentState.setState(() {
                    profileStudentState._selectedIndex = 1;
                  });
                }
              },
            ),
          ),
          // Посмотреть мои отзывы
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Посмотреть мои отзывы:",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BottonText(text: "Нажмите, чтобы выбрать из списка"),
          ),
          const SizedBox(height: 80),
        ],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Филин", style: TextStyle(fontSize: 24)),
                Text(
                  "Проект по поиску помощи в проектах",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottonText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const BottonText({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.85,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color.fromRGBO(199, 199, 199, 1),
            width: 1,
          ),
        ),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 13))),
      ),
    );
  }
}
