import 'package:flutter/material.dart';
import 'teacher_theme.dart';
import 'prof_block.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _searchQuery = '';

  final List<Map<String, String>> _students = [
    {'name': 'Иванов Иван', 'group': '251-333', 'direction': 'Информационные технологии'},
    {'name': 'Сергеев Сергей', 'group': '251-666', 'direction': 'Информационные технологии'},
    {'name': 'Валуева Валерия', 'group': '251-446', 'direction': 'Информационные технологии'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _students
        .where((s) => s['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
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
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: filtered.map((s) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ProfBlock(
                  text: s['name']!,
                  text_1: s['group']!,
                  text_2: s['direction']!,
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}