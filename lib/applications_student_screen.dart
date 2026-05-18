import 'package:flutter/material.dart';
import 'package:flutter_application_1/user_data.dart';
import 'package:flutter_application_1/api_service.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  bool _showFilters = false;
  String _selectedStatus = "Все";
  String _searchQuery = "";
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;

  final List<String> _statuses = [
    "Все",
    "На рассмотрении",
    "Принята",
    "Отклонена",
  ];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  // ДОБАВЬТЕ ЭТОТ МЕТОД - он вызывается каждый раз, когда экран становится видимым
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем заявки при каждом показе экрана
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
    });

    print('Loading applications for studentId: ${UserData.studentId}');

    final apps = await ApiService.getStudentApplications(
      UserData.studentId ?? 0,
    );

    print('Received ${apps.length} applications');

    setState(() {
      _applications = apps;
      _isLoading = false;
    });
  }

  // ДОБАВЬТЕ ПУБЛИЧНЫЙ МЕТОД для обновления извне (если нужно)
  void refreshApplications() {
    _loadApplications();
  }

  String _mapStatus(String dbStatus) {
    switch (dbStatus) {
      case 'pending':
        return 'На рассмотрении';
      case 'approved':
        return 'Принята';
      case 'rejected':
        return 'Отклонена';
      default:
        return 'На рассмотрении';
    }
  }

  List<Map<String, dynamic>> get _filteredApplications {
    return _applications.where((app) {
      String status = _mapStatus(app['status'] ?? 'pending');
      final matchesStatus =
          _selectedStatus == "Все" || status == _selectedStatus;
      final matchesSearch =
          _searchQuery.isEmpty ||
          (app['teacher_name'] ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (app['topic'] ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: _loadApplications, // ДОБАВЬТЕ возможность обновления свайпом
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
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
                    Icon(
                      _showFilters
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (_showFilters)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
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
                        hintText: "Поиск по имени или теме...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
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
                          onSelected: (_) =>
                              setState(() => _selectedStatus = status),
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
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filteredApplications.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: Text('У вас пока нет заявок')),
              )
            else
              ..._filteredApplications.map((app) => _buildApplicationCard(app)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    final screenWidth = MediaQuery.of(context).size.width;
    String status = _mapStatus(app['status'] ?? 'pending');
    Color statusColor;
    switch (status) {
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
          const Icon(
            Icons.assignment,
            size: 42,
            color: Color.fromRGBO(224, 167, 87, 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['teacher_name'] ?? 'Преподаватель',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(app['topic'] ?? '', style: const TextStyle(fontSize: 14)),
                Text(
                  app['department'] ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 10,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(app['created_at']),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 10, color: statusColor),
                      ),
                    ),
                  ],
                ),
                if (app['decision_comment'] != null &&
                    app['decision_comment'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Комментарий: ${app['decision_comment']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final date = DateTime.parse(dateTimeStr);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return '';
    }
  }
}
