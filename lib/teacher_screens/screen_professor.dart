import 'package:flutter/material.dart';
import 'filter_dialog.dart';
import 'chat_screen.dart';
import 'teacher_theme.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/user_data.dart';

class ScreenProfessor extends StatefulWidget {
  const ScreenProfessor({super.key});

  @override
  State<ScreenProfessor> createState() => _ScreenProfessorState();
}

class _ScreenProfessorState extends State<ScreenProfessor> {
  int _selectedTab = 0;
  String _searchQuery = '';

  // Реальные данные
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _notifications = [];

  bool _isLoadingRequests = true;
  bool _isLoadingChats = true;

  Set<String> _activeFilters = {'pending'}; // pending, approved, rejected

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadRequests(), _loadChats()]);
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoadingRequests = true;
    });

    final applications = await ApiService.getTeacherApplications(
      UserData.teacherId ?? 0,
    );

    setState(() {
      _requests = applications;
      _isLoadingRequests = false;
    });
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoadingChats = true;
    });

    final chats = await ApiService.getTeacherChats(UserData.teacherId ?? 0);

    setState(() {
      _chats = chats;
      _isLoadingChats = false;
    });
  }

  String _mapStatus(String dbStatus) {
    switch (dbStatus) {
      case 'pending':
        return 'Без статуса';
      case 'approved':
        return 'Одобрено';
      case 'rejected':
        return 'Отклонено';
      default:
        return 'Без статуса';
    }
  }

  String _reverseMapStatus(String displayStatus) {
    switch (displayStatus) {
      case 'Без статуса':
        return 'pending';
      case 'Одобрено':
        return 'approved';
      case 'Отклонено':
        return 'rejected';
      default:
        return 'pending';
    }
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
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
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

  Widget _buildChatsList() {
    if (_isLoadingChats) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _chats.where((c) {
      final studentName = (c['student_name'] ?? '').toLowerCase();
      return studentName.contains(_searchQuery.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Нет чатов'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final chat = filtered[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  name: chat['student_name'] ?? 'Студент',
                  group: chat['group_name'] ?? '',
                  chatId: chat['id'],
                  isTeacher: true,
                ),
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
                        chat['student_name'] ?? 'Студент',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(chat['last_message'] ?? 'Нет сообщений'),
                    ],
                  ),
                ),
                Text(
                  _formatTime(chat['last_time']),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    if (_isLoadingRequests) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _requests.where((req) {
      final name = (req['student_name'] ?? '').toLowerCase();
      final matchSearch = name.contains(_searchQuery.toLowerCase());
      final status = req['status'] ?? 'pending';
      return matchSearch && _activeFilters.contains(status);
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Нет заявок'));
    }

    return Column(
      children: [
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
              final status = _mapStatus(req['status'] ?? 'pending');
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
                              req['student_name'] ?? 'Студент',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${req['group_name'] ?? ''} • ${req['department'] ?? ''}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Статус: $status',
                              style: TextStyle(
                                fontSize: 13,
                                color: status == 'Отклонено'
                                    ? TeacherTheme.red
                                    : status == 'Одобрено'
                                    ? TeacherTheme.green
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (status == 'Без статуса')
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

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return ListTile(
          leading: const Icon(
            Icons.notifications,
            size: 42,
            color: TeacherTheme.goldIcon,
          ),
          title: Text(notification['title'] ?? ''),
          subtitle: Text(notification['message'] ?? ''),
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

  void _showRequestDetails(Map<String, dynamic> req) async {
    final topicController = TextEditingController(text: req['topic'] ?? '');
    final status = _mapStatus(req['status'] ?? 'pending');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (ctx, setStateBottom) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Заявка от студента',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _detailRow('ФИО', req['student_name'] ?? ''),
                  _detailRow('Группа', req['group_name'] ?? ''),
                  _detailRow('Направление', req['department'] ?? ''),
                  _detailRow('Тема проекта', req['topic'] ?? ''),
                  _detailRow('Статус', status),
                  if (status == 'Без статуса') ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: topicController,
                      decoration: const InputDecoration(
                        labelText: 'Комментарий (опционально)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result =
                                await ApiService.updateApplicationStatus(
                                  applicationId: req['id'],
                                  status: 'approved',
                                  decisionComment: topicController.text,
                                );
                            if (result != null) {
                              await _loadRequests();
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Заявка принята'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TeacherTheme.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Принять'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result =
                                await ApiService.updateApplicationStatus(
                                  applicationId: req['id'],
                                  status: 'rejected',
                                  decisionComment: topicController.text,
                                );
                            if (result != null) {
                              await _loadRequests();
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Заявка отклонена'),
                                  ),
                                );
                              }
                            }
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
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final date = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      if (date.day == now.day && date.month == now.month) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (date.day == now.day - 1) {
        return 'вчера';
      }
      return '${date.day}.${date.month}';
    } catch (e) {
      return '';
    }
  }
}
