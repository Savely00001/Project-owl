import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final String teacherName;
  final String teacherPosition;
  final String teacherDepartment;

  const ReviewScreen({
    super.key,
    required this.teacherName,
    required this.teacherPosition,
    required this.teacherDepartment,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 5;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitted = false;
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Оставить отзыв"),
        backgroundColor: const Color.fromRGBO(94, 71, 61, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTeacherInfo(),
            const SizedBox(height: 20),
            _buildRatingStars(),
            const SizedBox(height: 20),
            if (_isSubmitted && !_isPending) _buildSubmittedView(),
            if (_isPending) _buildPendingView(),
            if (!_isSubmitted && !_isPending) _buildReviewForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 50, color: Color.fromRGBO(224, 167, 87, 1)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.teacherName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(widget.teacherPosition, style: const TextStyle(fontSize: 14)),
                Text(widget.teacherDepartment, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Column(
      children: [
        const Text("Оценка", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
                onPressed: () => setState(() => _rating = index + 1),
              );
            }),
          ],
        ),
        Text("${_rating.toStringAsFixed(0)}/5", style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildReviewForm() {
    return Column(
      children: [
        TextField(
          controller: _commentController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Введите текст отзыва",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        ),
        const SizedBox(height: 20),
        _buildButton("Отправить отзыв", () {
          if (_commentController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Пожалуйста, напишите текст отзыва")),
            );
            return;
          }
          setState(() {
            _isPending = true;
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isPending = false;
              _isSubmitted = true;
            });
          });
        }),
      ],
    );
  }

  Widget _buildPendingView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.hourglass_empty, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          const Text(
            "Мы проверяем ваш отзыв перед публикацией.\nЭто может занять некоторое время",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          _buildButton("Отменить заявку", () {
            setState(() {
              _isPending = false;
              _commentController.clear();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSubmittedView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 50, color: Colors.green),
          const SizedBox(height: 10),
          const Text("Спасибо за отзыв!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Он будет опубликован после проверки модератором"),
          const SizedBox(height: 15),
          _buildButton("Написать ещё", () {
            setState(() {
              _isSubmitted = false;
              _commentController.clear();
              _rating = 5;
            });
          }),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Вернуться к преподавателю"),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16))),
      ),
    );
  }
}
