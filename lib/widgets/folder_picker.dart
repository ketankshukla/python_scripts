import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<String?> selectFolder(BuildContext context) async {
  try {
    String? selectedDirectoryPath = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a folder to process');
    if (selectedDirectoryPath != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Folder selected: $selectedDirectoryPath')));
      return selectedDirectoryPath;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No folder selected')));
      return null;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error selecting folder: $e')));
    return null;
  }
}
