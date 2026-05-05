import 'package:flutter/material.dart';
import 'package:flutter_application_1/applications_student_screen.dart';
import 'package:flutter_application_1/alerts_student_screen.dart';

class Incoming extends StatefulWidget {
  const Incoming({super.key});

  @override
  State<Incoming> createState() => _IncomingState();
}

class _IncomingState extends State<Incoming> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    const Chats(),
    const Application(),
    const Alert(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabButtons(),
            IndexedStack(index: _selectedTabIndex, children: _tabs),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Филин", style: TextStyle(fontSize: 24)),
                Text(
                  "Проект по поиску помощи в проектах",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTabButton(
            isSelected: _selectedTabIndex == 0,
            text: "Чаты",
            onTap: () => setState(() => _selectedTabIndex = 0),
          ),
          CustomTabButton(
            isSelected: _selectedTabIndex == 1,
            text: "Заявки",
            onTap: () => setState(() => _selectedTabIndex = 1),
          ),
          CustomTabButton(
            isSelected: _selectedTabIndex == 2,
            text: "Оповещения",
            onTap: () => setState(() => _selectedTabIndex = 2),
          ),
        ],
      ),
    );
  }
}

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Поиск...',
              filled: true,
              fillColor: Color.fromRGBO(227, 227, 227, 1.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Color.fromRGBO(227, 227, 227, 1.0),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.85,
          padding: const EdgeInsets.all(17),
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Color.fromRGBO(227, 227, 227, 1.0),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Иванов Иван", style: TextStyle(fontSize: 14)),
                  const Text(
                    "Информационные технологии",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Здравствуйте!....",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTabButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const CustomTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        width: screenWidth * 0.25,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(94, 71, 61, 1)
              : const Color.fromRGBO(218, 218, 218, 1),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
