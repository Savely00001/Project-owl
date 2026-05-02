import 'package:flutter/material.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

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

            // Иконка ошибки
            const Icon(Icons.cancel, size: 100, color: Colors.red),

            const SizedBox(height: 30),

            // Заголовок
            const Text(
              "Модерация отклонена",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Подзаголовок
            const Text(
              "Мы не смогли подтвердить вашу учетную запись.\nПроверьте, правильно ли вы ввели данные",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const Spacer(),

            // Кнопка "Исправить данные"
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Возврат к заполнению профиля
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(94, 71, 61, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Исправить данные",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
