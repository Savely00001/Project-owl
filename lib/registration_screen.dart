import 'package:flutter/material.dart';
import 'package:flutter_application_1/file_upload_widget.dart';
import 'package:flutter_application_1/pending_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/user_data.dart';

class ProfileFillScreen extends StatefulWidget {
  const ProfileFillScreen({super.key});

  @override
  State<ProfileFillScreen> createState() => _ProfileFillScreenState();
}

class _ProfileFillScreenState extends State<ProfileFillScreen> {
  String _selectedRole = 'student';
  String _inputGroup = "";
  String _inputName = "";
  String _inputDirection = "";
  String _inputStatus = "";
  String _inputNum = "";
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _studentsCountController =
      TextEditingController();

  FilePickerResult? _selectedDocument;
  String? _errorMessage;

  void _submitForm() {
    // Валидация ФИО
    if (_fullNameController.text.isEmpty) {
      setState(() {
        _errorMessage = "Ошибка! Вы не заполнили поля ФИО";
      });
      return;
    }

    // Валидация в зависимости от роли
    if (_selectedRole == 'student') {
      if (_groupController.text.isEmpty || _departmentController.text.isEmpty) {
        setState(() {
          _errorMessage = "Ошибка! Вы не заполнили поля";
        });
        return;
      }
    } else {
      if (_positionController.text.isEmpty ||
          _studentsCountController.text.isEmpty) {
        setState(() {
          _errorMessage = "Ошибка! Вы не заполнили поля";
        });
        return;
      }
    }

    // Проверка наличия документа
    if (_selectedDocument == null) {
      setState(() {
        _errorMessage = "Ошибка! Вы не прикрепили документ";
      });
      return;
    }
    // Очищаем ошибку
    setState(() {
      _errorMessage = null;
    });
    //Группа
    String text = _groupController.text;
    setState(() {
      _inputGroup = text;
    });
    //ФИО
    String text1 = _fullNameController.text;
    setState(() {
      _inputName = text1;
    });
    //Факультет
    String text2 = _departmentController.text;
    setState(() {
      _inputDirection = text2;
    });
    //Сохраняем введённые данные
    UserData.name = _inputName;
    UserData.group = _inputGroup;
    UserData.department = _inputDirection;
    // TODO: Здесь будет отправка данных на сервер
    // Пока просто переходим на экран ожидания
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PendingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
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
                          children: [
                            const Text("Филин", style: TextStyle(fontSize: 24)),
                            const Text(
                              "Проект по поиску помощи в проектах",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Заголовок
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Заполнение профиля",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),

                // Подзаголовок
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Укажите свои персональные данные и прикрепите документ для подтверждения",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Выбор роли
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Выберите роль",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: _RoleButton(
                          role: "студент",
                          isSelected: _selectedRole == 'student',
                          onTap: () =>
                              setState(() => _selectedRole = 'student'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _RoleButton(
                          role: "преподаватель",
                          isSelected: _selectedRole == 'teacher',
                          onTap: () =>
                              setState(() => _selectedRole = 'teacher'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Поле ФИО
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ФИО",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      hintText: "Иванов Иван Иванович",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(94, 71, 61, 1),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Динамические поля
                if (_selectedRole == 'student') ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Группа",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: _groupController,
                      decoration: const InputDecoration(
                        hintText: "111–222",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(94, 71, 61, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Факультет",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: _departmentController,
                      decoration: const InputDecoration(
                        hintText: "Информационные технологии",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(94, 71, 61, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Должность",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        hintText: "Доцент",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(94, 71, 61, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Количество студентов, которых могу курировать",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: _studentsCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "0",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(94, 71, 61, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Загрузка документа
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: FileUploadWidget(
                    label: "Документы для подтверждения",
                    subtitle: _selectedRole == 'student'
                        ? "Документ, подтверждающий личность (зачетная книжка)"
                        : "Документ, подтверждающий личность",
                    onFileSelected: (result) {
                      setState(() {
                        _selectedDocument = result;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Сообщение об ошибке
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 10),

                // Кнопка отправки
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: _SubmitButton(onTap: _submitForm),
                ),

                const SizedBox(height: 20),

                // Подпись
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Text(
                    "Данные можно будет изменить позже в профиле",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(94, 71, 61, 1)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            role,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SubmitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        width: screenWidth * 0.85,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromRGBO(94, 71, 61, 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Center(
          child: Text(
            "Отправить на проверку",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
