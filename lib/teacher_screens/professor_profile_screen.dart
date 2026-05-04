import 'package:flutter/material.dart';
import 'prof_botton_text.dart';
import 'edit_professor_profile_screen.dart';
import 'teacher_theme.dart';

class ProfessorProfileScreen extends StatelessWidget {
  const ProfessorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                IconButton(
                  icon: const Icon(Icons.edit, color: TeacherTheme.primaryBrown),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfessorProfileScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text("Мой профиль", style: TextStyle(fontSize: 32)),
          ),
          // Карточка по центру
          Center(
            child: Container(
              width: screenWidth * 0.85,
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: TeacherTheme.lightGray, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_circle, size: 42, color: TeacherTheme.goldIcon),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Иванов Иван", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Информационные технологии", style: TextStyle(fontSize: 14)),
                      SizedBox(height: 4),
                      Text("Учебное звание: Доцент", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Выбор направлений
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 30, bottom: 10),
            child: Text("Выбранные направления, с которыми я готов работать:",
                style: TextStyle(fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => _showDirectionsDialog(context),
              child: ProfBottonText(text: "Нажмите, чтобы выбрать"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 16),
            child: Text("Информационные технологии",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 8),
            child: Text("Физика", style: TextStyle(fontSize: 14, color: Colors.black54)),
          ),
          // Количество студентов
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 30, bottom: 10),
            child: Text("Количество студентов, которых готов курировать:",
                style: TextStyle(fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                const Text("5/10", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: TeacherTheme.lightGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(TeacherTheme.primaryBrown),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Рейтинг
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 30, bottom: 10),
            child: Text("Мой рейтинг:", style: TextStyle(fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                const Text("4,9/5", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.98,
                    backgroundColor: TeacherTheme.lightGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(TeacherTheme.primaryBrown),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

void _showDirectionsDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => const DirectionSelector(),
  );
}

// Виджет выбора направлений по категориям
class DirectionSelector extends StatefulWidget {
  const DirectionSelector({super.key});
  @override
  State<DirectionSelector> createState() => _DirectionSelectorState();
}

class _DirectionSelectorState extends State<DirectionSelector> {
  final Map<String, bool> _selected = {
    'Информационные технологии': true,
    'Физика': true,
    'Машиностроение': false,
    'Биохимия': false,
    'Лингвистика': false,
    'История': false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Выберите направления',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._selected.keys.map((direction) => CheckboxListTile(
            title: Text(direction),
            value: _selected[direction],
            activeColor: TeacherTheme.primaryBrown,
            onChanged: (v) => setState(() => _selected[direction] = v!),
          )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherTheme.primaryBrown,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            ),
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }
}