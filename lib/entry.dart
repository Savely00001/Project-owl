import 'package:flutter/material.dart';
import 'package:flutter_application_1/entry_2.dart';
import 'package:flutter_application_1/code.dart';

class Entry extends StatelessWidget {
  const Entry({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
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
                Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text("Вход", style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      "Введите номер телефона",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: TextField(
                    cursorColor: Color.fromRGBO(94, 71, 61, 1),
                    decoration: InputDecoration(
                      hintText: '+7(999)1234567',
                      fillColor: Color.fromRGBO(136, 132, 132, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(94, 71, 61, 1),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: MyBotton(),
                ),
                SizedBox(height: 30),
                Text("Ещё нет аккаунта?", style: TextStyle(fontSize: 32)),
                SizedBox(height: 20),
                MyBotton2(),
              ],
            ),
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
          MaterialPageRoute(builder: (context) => Code2()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        width: screenWidth * 0.85,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Center(
          child: Text(
            "Получить код",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class MyBotton2 extends StatelessWidget {
  const MyBotton2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Entry2()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        width: screenWidth * 0.85,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Center(
          child: Text(
            "Зарегистрироваться",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
