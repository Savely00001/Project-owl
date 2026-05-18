import 'package:flutter/material.dart';
import 'teacher_theme.dart';
import 'prof_block.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/user_data.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    final students = await ApiService.getTeacherStudents(
      UserData.teacherId ?? 0,
    );

    // Преобразуем в нужный формат
    final formattedStudents = students
        .map(
          (s) => {
            'name': s['student_name'] ?? '',
            'group': s['group_name'] ?? '',
            'direction': s['department'] ?? '',
          },
        )
        .toList();

    setState(() {
      _students = formattedStudents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _students
        .where(
          (s) => s['name']!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    children: const [
                      Text("Филин", style: TeacherTheme.headerStyle),
                      Text(
                        "Проект по поиску помощи в проектах",
                        style: TeacherTheme.subHeaderStyle,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text("Мои студенты", style: TeacherTheme.titleStyle),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Поиск по ключевым словам',
                filled: true,
                fillColor: TeacherTheme.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: TeacherTheme.lightGray),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (filtered.isEmpty)
            const Center(child: Text('У вас пока нет студентов'))
          else
            Center(
              child: Column(
                children: filtered
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ProfBlock(
                          text: s['name']!,
                          text_1: s['group']!,
                          text_2: s['direction']!,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
