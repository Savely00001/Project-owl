import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatefulWidget {
  final String label;
  final String? subtitle;
  final double maxSizeMB;
  final bool showRemoveButton;
  
  const FileUploadWidget({
    super.key,
    this.label = "Документы для подтверждения",
    this.subtitle,
    this.maxSizeMB = 30,
    this.showRemoveButton = true,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  PlatformFile? _selectedFile;
  String? _errorMessage;

  Future<void> _pickFile() async {
    try {
      setState(() {
        _errorMessage = null;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        // Проверка размера
        if (file.size > widget.maxSizeMB * 1024 * 1024) {
          setState(() {
            _errorMessage = 'Файл слишком большой! Максимум ${widget.maxSizeMB} МБ';
          });
          return;
        }
        
        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при выборе файла';
      });
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _errorMessage = null;
    });
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.subtitle!,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
        const SizedBox(height: 8),
        
        if (_errorMessage != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            height: _selectedFile != null ? 120 : 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedFile != null ? Colors.green : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _selectedFile != null ? Colors.green.shade50 : null,
            ),
            child: _selectedFile != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 40, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedFile!.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _formatBytes(_selectedFile!.size),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (widget.showRemoveButton)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: _removeFile,
                          ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 42, color: Colors.grey.shade500),
                      const SizedBox(height: 8),
                      Text(
                        "Нажмите для выбора файла",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        "PDF, JPG, PNG до ${widget.maxSizeMB} МБ",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
