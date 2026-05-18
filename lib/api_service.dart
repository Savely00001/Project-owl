import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/user_data.dart';

class ApiService {
  // Динамический baseUrl в зависимости от платформы
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // Для Android эмулятора
    }
    // Для iOS симулятора или реального устройства
    return 'http://localhost:8080';
  }

  // ==================== СТУДЕНТЫ ====================

  // 1. Создание студента после регистрации
  static Future<Map<String, dynamic>?> createStudent({
    required String fullName,
    required String groupName,
    required String department,
    String topic = '',
  }) async {
    try {
      print('Creating student at: $baseUrl/students');
      print(
        'Data: full_name=$fullName, group_name=$groupName, department=$department',
      );

      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': fullName,
          'group_name': groupName,
          'department': department,
          'topic': topic,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        UserData.studentId = data['id'];
        print('Student created with ID: ${UserData.studentId}');
        return data;
      } else {
        print('Error creating student: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception creating student: $e');
      return null;
    }
  }

  // 2. Получение заявок студента
  static Future<List<Map<String, dynamic>>> getStudentApplications(
    int studentId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/applications?student_id=$studentId');
      print('Getting applications from: $url');

      final response = await http.get(url);

      print('Applications response status: ${response.statusCode}');
      print('Applications response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Loaded ${data.length} applications');
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting applications: $e');
      return [];
    }
  }

  // ==================== ПРЕПОДАВАТЕЛИ ====================

  // 3. Получение списка преподавателей
  static Future<List<Map<String, dynamic>>> getTeachers({
    String query = '',
  }) async {
    try {
      final url = query.isEmpty
          ? Uri.parse('$baseUrl/teachers')
          : Uri.parse('$baseUrl/teachers?q=$query');
      print('Getting teachers from: $url');

      final response = await http.get(url);

      print('Teachers response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Loaded ${data.length} teachers');
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting teachers: $e');
      return [];
    }
  }

  // ==================== ЗАЯВКИ ====================

  // 4. Отправка заявки преподавателю (студент)
  static Future<Map<String, dynamic>?> createApplication({
    required int studentId,
    required int teacherId,
    required String topic,
  }) async {
    try {
      print('Creating application at: $baseUrl/applications');
      print('Data: student_id=$studentId, teacher_id=$teacherId, topic=$topic');

      final response = await http.post(
        Uri.parse('$baseUrl/applications'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'student_id': studentId,
          'teacher_id': teacherId,
          'topic': topic,
        }),
      );

      print('Application response status: ${response.statusCode}');
      print('Application response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Error creating application: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception creating application: $e');
      return null;
    }
  }

  // 5. Получение всех заявок (для администратора)
  static Future<List<Map<String, dynamic>>> getAllApplications({
    String? status,
    int? teacherId,
  }) async {
    try {
      String url = '$baseUrl/applications';
      final params = <String, String>{};
      if (status != null) params['status'] = status;
      if (teacherId != null) params['teacher_id'] = teacherId.toString();

      if (params.isNotEmpty) {
        url += '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
      }

      print('Getting all applications from: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting applications: $e');
      return [];
    }
  }

  // 6. Получение заявок для преподавателя
  static Future<List<Map<String, dynamic>>> getTeacherApplications(
    int teacherId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/applications?teacher_id=$teacherId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting teacher applications: $e');
      return [];
    }
  }

  // 7. Обновление статуса заявки (принять/отклонить)
  static Future<Map<String, dynamic>?> updateApplicationStatus({
    required int applicationId,
    required String status, // 'approved' или 'rejected'
    required String decisionComment,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/applications/$applicationId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': status,
          'decision_comment': decisionComment,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error updating application: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception updating application: $e');
      return null;
    }
  }

  // 8. Получение списка студентов преподавателя (одобренные заявки)
  static Future<List<Map<String, dynamic>>> getTeacherStudents(
    int teacherId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/applications?teacher_id=$teacherId&status=approved',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting teacher students: $e');
      return [];
    }
  }

  // ==================== ЧАТЫ ====================

  // 9. Получение всех чатов преподавателя
  static Future<List<Map<String, dynamic>>> getTeacherChats(
    int teacherId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats?teacher_id=$teacherId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting teacher chats: $e');
      return [];
    }
  }

  // 10. Получение всех чатов студента
  static Future<List<Map<String, dynamic>>> getStudentChats(
    int studentId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats?student_id=$studentId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting student chats: $e');
      return [];
    }
  }

  // 11. Получение сообщений чата
  static Future<List<Map<String, dynamic>>> getChatMessages(int chatId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Exception getting chat messages: $e');
      return [];
    }
  }

  // 12. Отправка сообщения в чат
  static Future<Map<String, dynamic>?> sendMessage({
    required int chatId,
    required String senderRole,
    required int senderId,
    required String text,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender_role': senderRole,
          'sender_id': senderId,
          'text': text,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Error sending message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception sending message: $e');
      return null;
    }
  }
}
