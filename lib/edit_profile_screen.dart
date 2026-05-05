import 'package:flutter/material.dart';
import 'package:flutter_application_1/user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = UserData.name;
    _groupController.text = UserData.group;
    _departmentController.text = UserData.department;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      UserData.name = _nameController.text;
      UserData.group = _groupController.text;
      UserData.department = _departmentController.text;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("✅ Данные сохранены!")));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактирование профиля"),
        backgroundColor: const Color.fromRGBO(94, 71, 61, 1),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildTextField("ФИО", _nameController, "Иванов Иван Иванович"),
              const SizedBox(height: 20),
              _buildTextField("Группа", _groupController, "111-222"),
              const SizedBox(height: 20),
              _buildTextField(
                "Кафедра",
                _departmentController,
                "Информационные технологии",
              ),
              const SizedBox(height: 40),
              _buildButton(
                Icons.save,
                "Сохранить изменения",
                _saveChanges,
                screenWidth,
              ),
              const SizedBox(height: 15),
              _buildButton(
                Icons.close,
                "Отмена",
                () => Navigator.pop(context, false),
                screenWidth,
                isCancel: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset('assets/Logo.png', width: 60, height: 60),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Филин", style: TextStyle(fontSize: 24)),
              Text(
                "Проект по поиску помощи в проектах",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    IconData icon,
    String text,
    VoidCallback onTap,
    double screenWidth, {
    bool isCancel = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isCancel
              ? Colors.grey.shade300
              : const Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isCancel ? Colors.red : Colors.green),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isCancel ? Colors.black87 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
