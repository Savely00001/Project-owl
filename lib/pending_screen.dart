import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile_student.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Шапка с логотипом
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

            const Spacer(),

            // Заголовок
            Text(
              "Проверка документов",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Подзаголовок
            const Text(
              "Ваша заявка отправлена на модерацию",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            // Иконка часов
            const Icon(Icons.hourglass_empty, size: 80, color: Colors.orange),

            const SizedBox(height: 30),

            // Текст ожидания
            const Text(
              "Пожалуйста, ожидайте решения",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Мы уведомим вас, когда проверка будет завершена.\nОбычно это занимает до 24 часов",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const Spacer(),

            // Кнопка "Изменить документы"
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileStudent()),
                ); // Возврат к заполнению профиля
              },
              child: const Text(
                "Перейти в профиль",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(94, 71, 61, 1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
