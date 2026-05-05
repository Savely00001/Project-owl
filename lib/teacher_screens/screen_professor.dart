import 'package:flutter/material.dart';
import 'filter_dialog.dart';
import 'chat_screen.dart';
import 'teacher_theme.dart';

class ScreenProfessor extends StatefulWidget {
  const ScreenProfessor({super.key});

  @override
  State<ScreenProfessor> createState() => _ScreenProfessorState();
}

class _ScreenProfessorState extends State<ScreenProfessor> {
  int _selectedTab = 0;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _requests = [
    {
      'name': 'Иванов Иван',
      'group': '251-333',
      'direction': 'Информационные технологии',
      'status': 'Без статуса',
    },
    {
      'name': 'Егоров Егор',
      'group': '261-332',
      'direction': 'Информационные технологии',
      'status': 'Отклонено',
    },
  ];

  final List<Map<String, String>> _chats = [
    {
      'name': 'Иванов Иван',
      'group': '251-333',
      'direction': 'Информационные технологии',
      'lastMessage': 'Здравствуйте!....',
      'time': '12:30',
    },
    {
      'name': 'Сергеев Сергей',
      'group': '251-666',
      'direction': 'Информационные технологии',
      'lastMessage': 'Прислал исправленную версию',
      'time': 'вчера',
    },
  ];

  final List<String> _notifications = [
    'Ваши документы подтверждены',
    'Новое сообщение от Анны',
    'Обновление в проекте',
  ];

  Set<String> _activeFilters = {'Без статуса', 'Отказ', 'Одобрено'};

  //  Шапка с логотипом
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

  //  Табы (Чаты / Заявки / Оповещения)
  Widget _buildTopButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _tabButton('Чаты', 0),
          const SizedBox(width: 16),
          _tabButton('Заявки', 1),
          const SizedBox(width: 16),
          _tabButton('Оповещения', 2),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          width: screenWidth * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: isSelected
                ? const Color.fromRGBO(94, 71, 61, 1)
                : const Color.fromRGBO(218, 218, 218, 1),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  //  Строка поиска и кнопка фильтр
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Поиск...',
                filled: true,
                fillColor: TeacherTheme.lightGray,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: TeacherTheme.lightGray),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (_selectedTab == 1)
            GestureDetector(
              onTap: _showFilterDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: TeacherTheme.lightGray,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Фильтр',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterDialog() async {
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterDialog(activeFilters: _activeFilters),
    );
    if (result != null) {
      setState(() => _activeFilters = result);
    }
  }

  //  Содержимое табов
  Widget _buildCurrentBody() {
    switch (_selectedTab) {
      case 0:
        return _buildChatsList();
      case 1:
        return _buildRequestsList();
      case 2:
        return _buildNotificationsList();
      default:
        return Container();
    }
  }

  //  ЧАТЫ
  Widget _buildChatsList() {
    final filtered = _chats
        .where(
          (c) => c['name']!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final chat = filtered[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(name: chat['name']!, group: chat['group']!),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: TeacherTheme.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: TeacherTheme.lightGray, width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 42,
                  color: TeacherTheme.goldIcon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('${chat['group']} • ${chat['direction']}'),
                      const SizedBox(height: 4),
                      Text(
                        chat['lastMessage']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  chat['time']!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //  ЗАЯВКИ
  Widget _buildRequestsList() {
    final filtered = _requests.where((req) {
      final name = (req['name'] as String).toLowerCase();
      final matchSearch = name.contains(_searchQuery.toLowerCase());
      final status = req['status'] as String;
      return matchSearch && _activeFilters.contains(status);
    }).toList();

    return Column(
      children: [
        // Заголовок с фильтром
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Фильтры:',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _showFilterDialog,
                child: const Text(
                  'Нажмите, чтобы выбрать',
                  style: TextStyle(
                    fontSize: 14,
                    color: TeacherTheme.primaryBrown,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final req = filtered[index];
              return GestureDetector(
                onTap: () => _showRequestDetails(req),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: TeacherTheme.white,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: TeacherTheme.lightGray, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 42,
                        color: TeacherTheme.goldIcon,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('${req['group']} • ${req['direction']}'),
                            const SizedBox(height: 4),
                            Text(
                              'Статус: ${req['status']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: req['status'] == 'Отклонено'
                                    ? TeacherTheme.red
                                    : req['status'] == 'Одобрено'
                                    ? TeacherTheme.green
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (req['status'] == 'Без статуса')
                        ElevatedButton(
                          onPressed: () => _showRequestDetails(req),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TeacherTheme.primaryBrown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: const Text('Открыть'),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //  оповещения
  Widget _buildNotificationsList() {
    final filtered = _notifications
        .where((n) => n.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final notification = filtered[index];
        return ListTile(
          leading: const Icon(
            Icons.notifications,
            size: 42,
            color: TeacherTheme.goldIcon,
          ),
          title: Text(notification),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherTheme.primaryBrown,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text('Посмотреть'),
          ),
        );
      },
    );
  }

  //  ДЕТАЛИ ЗАЯВКИ
  void _showRequestDetails(Map<String, dynamic> req) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Заявка от студента',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _detailRow('ФИО', req['name']),
              _detailRow('Группа', req['group']),
              _detailRow('Направление', req['direction']),
              _detailRow('Тема ВКР', 'Исследование методов машинного обучения'),
              _detailRow('Научный руководитель', 'Иванов Иван (Доцент)'),
              _detailRow('Статус', req['status']),
              const SizedBox(height: 20),
              if (req['status'] == 'Без статуса')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // здесь позже можно менять статус
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TeacherTheme.primaryBrown,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Принять'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TeacherTheme.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Отклонить'),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTopButtons(),
          _buildSearchAndFilter(),
          Expanded(child: _buildCurrentBody()),
        ],
      ),
    );
  }
}
