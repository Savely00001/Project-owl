import 'package:flutter/material.dart';
import 'teacher_theme.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:flutter_application_1/user_data.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String group;
  final int? chatId; // добавляем
  final bool isTeacher; // добавляем

  const ChatScreen({
    super.key,
    required this.name,
    required this.group,
    this.chatId,
    this.isTeacher = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (widget.chatId != null) {
      final messages = await ApiService.getChatMessages(widget.chatId!);
      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    // Временно добавляем сообщение в UI (оптимистичное обновление)
    final tempMessage = {
      'text': text,
      'sender_role': widget.isTeacher ? 'teacher' : 'student',
      'created_at': DateTime.now().toIso8601String(),
    };

    setState(() {
      _messages.add(tempMessage);
    });

    // Отправляем на сервер
    if (widget.chatId != null) {
      await ApiService.sendMessage(
        chatId: widget.chatId!,
        senderRole: widget.isTeacher ? 'teacher' : 'student',
        senderId: widget.isTeacher
            ? (UserData.teacherId ?? 0)
            : (UserData.studentId ?? 0),
        text: text,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.account_circle,
              size: 36,
              color: TeacherTheme.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.group, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: TeacherTheme.primaryBrown,
        foregroundColor: TeacherTheme.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(child: Text('Нет сообщений. Начните диалог!'))
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      final isMe =
                          message['sender_role'] ==
                          (widget.isTeacher ? 'teacher' : 'student');
                      return _MessageBubble(
                        text: message['text'] ?? '',
                        isMe: isMe,
                        time: _formatTime(message['created_at']),
                      );
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: TeacherTheme.lightGray),
                ),
                filled: true,
                fillColor: TeacherTheme.lightGray,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: TeacherTheme.primaryBrown),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const _MessageBubble({
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? TeacherTheme.primaryBrown : TeacherTheme.lightGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
