import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/file_upload_widget.dart';

class EditProfessorProfileScreen extends StatefulWidget {
  const EditProfessorProfileScreen({super.key});

  @override
  State<EditProfessorProfileScreen> createState() => _EditProfessorProfileScreenState();
}

class _EditProfessorProfileScreenState extends State<EditProfessorProfileScreen> {
  final _fullNameController = TextEditingController(text: 'Иванов Иван Иванович');
  final _positionController = TextEditingController(text: 'Доцент');
  final _studentsCountController = TextEditingController(text: '10');
  FilePickerResult? _selectedDocument;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Редактирование профиля'),
          backgroundColor: const Color.fromRGBO(94, 71, 61, 1),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ФИО
              const Text('ФИО', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Color.fromRGBO(94, 71, 61, 1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Должность
              const Text('Должность', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Color.fromRGBO(94, 71, 61, 1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Количество студентов
              const Text('Количество студентов, которых могу курировать',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                controller: _studentsCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Color.fromRGBO(94, 71, 61, 1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Документы
              const Text('Документы для подтверждения',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              if (_selectedDocument != null)
                Column(
                  children: [
                    Text('Документ подтвержден: ${_selectedDocument!.files.first.name}'),
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedDocument = null);
                      },
                      child: const Text('Удалить'),
                    ),
                  ],
                )
              else
                FileUploadWidget(
                  label: 'Документ, подтвержден',
                  subtitle: 'Нажмите, чтобы изменить или посмотреть',
                  onFileSelected: (result) {
                    setState(() => _selectedDocument = result);
                  },
                ),
              const SizedBox(height: 30),

              // Кнопка сохранения
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(94, 71, 61, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Сохранить', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}