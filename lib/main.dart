import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/folder_selection_button.dart';
import 'widgets/script_output_text_field.dart';
import 'widgets/script_selection_dropdown.dart';

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
    loadPythonScripts();
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
    try {
      String? selectedDirectoryPath = await FilePicker.platform
          .getDirectoryPath(dialogTitle: 'Select a folder to process');
      if (selectedDirectoryPath != null) {
        setState(() {
          folderPathToPass = selectedDirectoryPath;
          outputController.text = ''; // Clear the output TextField
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Folder selected: $folderPathToPass')));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No folder selected')));
      }
    } catch (e) {
      setState(() {
        outputController.text = 'Error selecting folder: $e';
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error selecting folder: $e')));
    }
  }

  void loadPythonScripts() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final scriptPaths = manifestMap.keys
        .where((String key) =>
            key.startsWith(scriptFolderPath) && key.endsWith('.py'))
        .toList();

    setState(() {
      pythonScripts = scriptPaths.map((path) => path.split('/').last).toList();
    });
  }

  void _runSelectedScript() async {
    if (selectedScript != null) {
      String scriptFullPath = '$scriptFolderPath/${selectedScript!}';
      Process process =
          await Process.start('python', [scriptFullPath, folderPathToPass]);

      outputController.text = '';

      process.stdout.transform(utf8.decoder).listen((data) {
        setState(() {
          outputController.text += 'stdout: $data\n';
        });
      });
      process.stderr.transform(utf8.decoder).listen((data) {
        setState(() {
          outputController.text += 'stderr: $data\n';
        });
      });

      int exitCode = await process.exitCode;
      if (exitCode == 0) {
        setState(() {
          outputController.text += 'Python script executed successfully\n';
        });
      } else {
        setState(() {
          outputController.text +=
              'Python script execution failed with exit code $exitCode\n';
        });
      }
    }
  }
}
