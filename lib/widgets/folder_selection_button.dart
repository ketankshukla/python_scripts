import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FolderSelectionButton extends StatelessWidget {
  final Function(String) onSelectFolder;

  const FolderSelectionButton({required this.onSelectFolder, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String? selectedDirectoryPath = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a folder to process');
        if (selectedDirectoryPath != null) {
          onSelectFolder(selectedDirectoryPath);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Folder selected: $selectedDirectoryPath')));
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No folder selected')));
        }
      },
      child: const Text('Select Folder to Process'),
    );
  }
}
