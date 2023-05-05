import 'package:flutter/material.dart';

class ScriptOutputTextField extends StatelessWidget {
  final TextEditingController controller;

  const ScriptOutputTextField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      maxLines: 10,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Script Output',
      ),
    );
  }
}
