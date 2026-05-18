import 'package:flutter/material.dart';
import 'teacher_reviews_screen.dart';
import 'chat_screen.dart';
import 'package:flutter_application_1/user_data.dart';
import 'package:flutter_application_1/api_service.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  bool _showFilters = false;
  String _selectedDepartment = "Все";
  String _searchQuery = "";

  // Объявляем переменные ДО методов
  List<Map<String, dynamic>> _teachers = [];
  bool _isLoading = true;

  final List<String> _departments = [
    "Все",
    "Информационные технологии",
    "Математика",
    "Физика",
    "Экономика",
  ];

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _isLoading = true;
    });

    final teachers = await ApiService.getTeachers();

    setState(() {
      _teachers = teachers;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredTeachers {
    return _teachers.where((teacher) {
      final matchesDepartment =
          _selectedDepartment == "Все" ||
          teacher['department'] == _selectedDepartment;
      final matchesSearch =
          _searchQuery.isEmpty ||
          teacher['full_name']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          teacher['department']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesDepartment && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Преподавательский состав",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              _buildFilterButton(),
              if (_showFilters) _buildFilters(),
              const SizedBox(height: 10),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_filteredTeachers.isEmpty)
                const Center(child: Text('Преподаватели не найдены'))
              else
                ..._filteredTeachers.map(
                  (teacher) => TeacherCard(
                    name: teacher['full_name']!,
                    position: teacher['position']!,
                    department: teacher['department']!,
                    onTap: () {
                      _showTeacherOptions(context, teacher);
                    },
                  ),
                ),

              const SizedBox(height: 80),
            ],
          ),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Филин", style: TextStyle(fontSize: 24)),
                Text(
                  "Проект по поиску помощи в проектах",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => setState(() => _showFilters = !_showFilters),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 13),
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _showFilters ? Icons.keyboard_arrow_up : Icons.filter_list,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              "Нажмите, для настройки поиска",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: const Color.fromRGBO(218, 218, 218, 1),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Фильтры:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "Поиск по имени или кафедре...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          const Text("Кафедра:", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _departments.map((dept) {
              return FilterChip(
                label: Text(dept),
                selected: _selectedDepartment == dept,
                onSelected: (_) => setState(() => _selectedDepartment = dept),
                backgroundColor: Colors.white,
                selectedColor: const Color.fromRGBO(
                  94,
                  71,
                  61,
                  1,
                ).withOpacity(0.2),
                checkmarkColor: const Color.fromRGBO(94, 71, 61, 1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showApplicationDialog(
    BuildContext context,
    Map<String, dynamic> teacher,
  ) {
    final topicController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Отправить заявку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Преподаватель: ${teacher['full_name']}'),
              const SizedBox(height: 16),
              TextField(
                controller: topicController,
                decoration: const InputDecoration(
                  labelText: 'Тема проекта/работы',
                  hintText: 'Введите тему вашего проекта',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (topicController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите тему проекта')),
                  );
                  return;
                }

                // Проверяем, что studentId не null
                if (UserData.studentId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ошибка: вы не авторизованы как студент'),
                    ),
                  );
                  Navigator.pop(context);
                  return;
                }

                Navigator.pop(context); // Закрываем диалог

                // Показываем загрузку
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final result = await ApiService.createApplication(
                  studentId: UserData.studentId!,
                  teacherId: teacher['id'],
                  topic: topicController.text.trim(),
                );

                Navigator.pop(context); // Закрываем загрузку

                if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Заявка успешно отправлена!')),
                  );

                  // ВАЖНО: Показываем диалог с предложением перейти к заявкам
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ошибка при отправке заявки. Проверьте соединение с сервером.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Отправить'),
            ),
          ],
        );
      },
    );
  }

  void _showTeacherOptions(BuildContext context, Map<String, dynamic> teacher) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 40,
                      color: Color.fromRGBO(224, 167, 87, 1),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teacher['full_name'] ?? teacher['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            teacher['department']!,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildModalButton(
                  icon: Icons.send,
                  text: "Отправить заявку",
                  onTap: () {
                    Navigator.pop(context);
                    _showApplicationDialog(context, teacher);
                  },
                ),
                _buildModalButton(
                  icon: Icons.chat_bubble_outline,
                  text: "Написать сообщение",
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Чат доступен после одобрения заявки'),
                      ),
                    );
                  },
                ),
                _buildModalButton(
                  icon: Icons.star_border,
                  text: "Посмотреть отзывы",
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Реализовать отзывы
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color.fromRGBO(94, 71, 61, 1), size: 22),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String position;
  final String department;
  final VoidCallback onTap;

  const TeacherCard({
    super.key,
    required this.name,
    required this.position,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: const Color.fromRGBO(218, 218, 218, 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.account_circle,
              size: 50,
              color: Color.fromRGBO(224, 167, 87, 1),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(department, style: const TextStyle(fontSize: 14)),
                  Text(
                    position,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
