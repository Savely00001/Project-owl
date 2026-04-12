import 'package:flutter/material.dart';
import 'package:flutter_application_2/teachers_screen_student_has.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //Верхняя часть
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Шапка с логотипом
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.asset('assets/logo.png', width: 60, height: 60),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Филин", style: TextStyle(fontSize: 24)),
                                Text(
                                  "Проект по поиску помощи в проектах",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Мой профиль",
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),

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
                            color: Color.fromRGBO(33, 173, 252, 1),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Иванов Иван",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "251-222",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const Text(
                                "Информационные технологии",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, bottom: 20),
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

                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, bottom: 20),
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
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 30, bottom: 20),
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
                      child: BottonText(
                        text: "Нажмите, чтобы выбрать из списка",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity, //Растягиваем на всю ширину экрана
              decoration: BoxDecoration(
                color: const Color.fromRGBO(199, 199, 199, 1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ButtonMain(
                      text: "Входящие",
                      icon: Icons.sms,
                      hasBack: false,
                      hasColor: true,
                    ),
                  ),
                  Expanded(
                    child: ButtonMain(
                      text: "Преподаватели",
                      icon: Icons.auto_stories,
                      hasBack: false,
                      hasColor: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Teachers(),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ButtonMain(
                      text: "Профиль",
                      icon: Icons.person,
                      hasBack: true,
                      hasColor: true,
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

class BottonText extends StatelessWidget {
  final String text;
  const BottonText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
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

class ButtonMain extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool hasBack;
  final bool hasColor;
  final VoidCallback? onTap;
  const ButtonMain({
    super.key,
    required this.text,
    required this.icon,
    required this.hasBack,
    required this.hasColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: hasBack ? Color.fromRGBO(33, 173, 252, 1) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: hasColor
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 0, 0, 0),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: hasColor
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

