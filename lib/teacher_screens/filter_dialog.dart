import 'package:flutter/material.dart';
import 'teacher_theme.dart';

class FilterDialog extends StatefulWidget {
  final Set<String> activeFilters;
  const FilterDialog({super.key, required this.activeFilters});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Фильтры поиска',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Без статуса'),
            value: _selected.contains('Без статуса'),
            onChanged: (v) {
              setState(() => v! ? _selected.add('Без статуса') : _selected.remove('Без статуса'));
            },
            activeColor: TeacherTheme.primaryBrown,
          ),
          CheckboxListTile(
            title: const Text('Отказ'),
            value: _selected.contains('Отказ'),
            onChanged: (v) {
              setState(() => v! ? _selected.add('Отказ') : _selected.remove('Отказ'));
            },
            activeColor: TeacherTheme.primaryBrown,
          ),
          CheckboxListTile(
            title: const Text('Одобрено'),
            value: _selected.contains('Одобрено'),
            onChanged: (v) {
              setState(() => v! ? _selected.add('Одобрено') : _selected.remove('Одобрено'));
            },
            activeColor: TeacherTheme.primaryBrown,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _selected),
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherTheme.primaryBrown,
              foregroundColor: TeacherTheme.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            ),
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }
}