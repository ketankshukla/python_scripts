import 'package:flutter/material.dart';
import 'widgets/folder_selection_button.dart';
import 'widgets/script_output_text_field.dart';
import 'widgets/script_selection_dropdown.dart';
import 'widgets/folder_picker.dart';
import 'widgets/script_loader.dart';
import 'widgets/script_runner_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Python Script Runner'),
        ),
        body: const Center(
          child: ScriptRunner(),
        ),
      ),
    );
  }
}

class ScriptRunner extends StatefulWidget {
  const ScriptRunner({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScriptRunnerState createState() => _ScriptRunnerState();
}

class _ScriptRunnerState extends State<ScriptRunner> {
  List<String> pythonScripts = [];
  String? selectedScript;
  TextEditingController outputController = TextEditingController();
  final String scriptFolderPath = 'assets/python_scripts';

  // Initialize the folderPathToPass variable with an empty value
  String folderPathToPass = '';

  @override
  void initState() {
    super.initState();
    _loadPythonScripts();
  }

  void _loadPythonScripts() async {
    List<String> scripts = await loadPythonScripts();
    setState(() {
      pythonScripts = scripts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          FolderSelectionButton(onSelectFolder: (path) {
            setState(() {
              folderPathToPass = path;
              outputController.text = ''; // Clear the output TextField
            });
          }),
          const Text('Select a Python script from the list:'),
          ScriptSelectionDropdown(
            pythonScripts: pythonScripts,
            selectedScript: selectedScript,
            onChanged: (String? newValue) {
              setState(() {
                selectedScript = newValue;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: selectedScript == null ? null : _runSelectedScript,
            child: const Text('Run Selected Script'),
          ),
          const SizedBox(height: 10),
          ScriptOutputTextField(controller: outputController),
        ],
      ),
    );
  }

  // ignore: unused_element
  Future<void> _selectFolder() async {
    String? selectedFolderPath = await selectFolder(context);
    if (selectedFolderPath != null) {
      setState(() {
        folderPathToPass = selectedFolderPath;
        outputController.text = ''; // Clear the output TextField
      });
    }
  }

  void _runSelectedScript() async {
  if (selectedScript != null) {
    Map<String, String> result = await runSelectedScript(
        scriptFolderPath, selectedScript!, folderPathToPass);

    setState(() {
      outputController.text = '${result['output']}\n${result['error']}';
    });
  }
}

}
