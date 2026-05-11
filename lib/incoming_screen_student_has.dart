import 'package:flutter/material.dart';
import 'package:flutter_application_1/applications_student_screen.dart';
import 'package:flutter_application_1/alerts_student_screen.dart';
import 'package:flutter_application_1/chat_screen.dart';

class Incoming extends StatefulWidget {
  const Incoming({super.key});

  @override
  State<Incoming> createState() => _IncomingState();
}

class _IncomingState extends State<Incoming> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    const ChatsList(),
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
            IndexedStack(
              index: _selectedTabIndex,
              children: _tabs,
            ),
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
                Text("Проект по поиску помощи в проектах", style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
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

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {
      'name': 'Иванов Иван Иванович',
      'department': 'Информационные технологии',
      'lastMessage': 'Здравствуйте! Когда будет готов проект?',
      'time': '14:30',
      'unread': 2,
    },
    {
      'name': 'Сергеев Сергей Сергеевич',
      'department': 'Информационные технологии',
      'lastMessage': 'Отлично, жду вашу работу',
      'time': '12:15',
      'unread': 0,
    },
    {
      'name': 'Валуева Валерия Викторовна',
      'department': 'Информационные технологии',
      'lastMessage': 'Спасибо за отзыв!',
      'time': 'Вчера',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  teacherName: chat['name'],
                  teacherDepartment: chat['department'],
                ),
              ),
            );
          },
          child: Container(
            width: screenWidth * 0.85,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(218, 218, 218, 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, size: 50, color: Color.fromRGBO(224, 167, 87, 1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'],
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            chat['time'],
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(chat['department'], style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['lastMessage'],
                              style: TextStyle(
                                fontSize: 13,
                                color: chat['unread'] > 0 ? Colors.black87 : Colors.grey.shade600,
                                fontWeight: chat['unread'] > 0 ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat['unread'] > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(94, 71, 61, 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${chat['unread']}',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          color: isSelected ? const Color.fromRGBO(94, 71, 61, 1) : const Color.fromRGBO(218, 218, 218, 1),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      ),
    );
  }
}