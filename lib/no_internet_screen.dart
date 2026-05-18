import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

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

            // Иконка отсутствия сети
            const Icon(Icons.wifi_off, size: 80, color: Colors.grey),

            const SizedBox(height: 30),

            // Заголовок
            const Text(
              "Отсутствует подключение",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Подзаголовок
            const Text(
              "Не удается подключиться к сети.\nПожалуйста, проверьте соединение и попробуйте снова",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const Spacer(),

            // Кнопка "Попробовать снова"
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
              child: GestureDetector(
                onTap: onRetry,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(94, 71, 61, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Попробовать снова",
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
