import 'package:flutter/material.dart';

class ScriptSelectionDropdown extends StatelessWidget {
  final List<String> pythonScripts;
  final String? selectedScript;
  final void Function(String?) onChanged;

  const ScriptSelectionDropdown({
    required this.pythonScripts,
    required this.selectedScript,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedScript,
      items: pythonScripts.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      hint: const Text('Select a script'),
    );
  }
}
