import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  bool _showFilters = false;
  String _selectedStatus = "Все";
  String _searchQuery = "";

  final List<String> _statuses = [
    "Все",
    "На рассмотрении",
    "Принята",
    "Отклонена",
  ];

  final List<Map<String, String>> _allApplications = [
    {'name': 'Иванов Иван', 'department': 'Информационные технологии', 'topic': 'Разработка мобильного приложения', 'status': 'На рассмотрении', 'date': '15.03.2024'},
    {'name': 'Петров Петр', 'department': 'Математика', 'topic': 'Исследование алгоритмов', 'status': 'Принята', 'date': '10.03.2024'},
    {'name': 'Сидорова Анна', 'department': 'Физика', 'topic': 'Моделирование процессов', 'status': 'Отклонена', 'date': '05.03.2024'},
  ];

  List<Map<String, String>> get _filteredApplications {
    return _allApplications.where((app) {
      final matchesStatus = _selectedStatus == "Все" || app['status'] == _selectedStatus;
      final matchesSearch = _searchQuery.isEmpty ||
          app['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app['topic']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showFilters = !_showFilters),
          child: Container(
            margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
            padding: const EdgeInsets.all(17),
            width: screenWidth * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(218, 218, 218, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Фильтры:",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Icon(_showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (_showFilters)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: const EdgeInsets.all(16),
            width: screenWidth * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(218, 218, 218, 1),
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "🔍 Поиск по имени или теме...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 12),
                const Text("Статус:", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _statuses.map((status) {
                    return FilterChip(
                      label: Text(status),
                      selected: _selectedStatus == status,
                      onSelected: (_) => setState(() => _selectedStatus = status),
                      backgroundColor: Colors.white,
                      selectedColor: const Color.fromRGBO(94, 71, 61, 1).withOpacity(0.2),
                      checkmarkColor: const Color.fromRGBO(94, 71, 61, 1),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ..._filteredApplications.map((app) => _buildApplicationCard(app)),
      ],
    );
  }

  Widget _buildApplicationCard(Map<String, String> app) {
    final screenWidth = MediaQuery.of(context).size.width;
    Color statusColor;
    switch (app['status']) {
      case 'Принята':
        statusColor = Colors.green;
        break;
      case 'Отклонена':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      width: screenWidth * 0.85,
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: const Color.fromRGBO(218, 218, 218, 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment, size: 42, color: Color.fromRGBO(224, 167, 87, 1)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app['name']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text(app['topic']!, style: const TextStyle(fontSize: 14)),
                Text(app['department']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 10, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(app['date']!, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        app['status']!,
                        style: TextStyle(fontSize: 10, color: statusColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}