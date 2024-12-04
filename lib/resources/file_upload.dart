import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FileUploadScreen extends StatelessWidget {
  const FileUploadScreen({super.key});

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      // Upload file to cloud storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickFile,
          child: const Text('Select File to Upload'),
        ),
      ),
    );
  }
}
