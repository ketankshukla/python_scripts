import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  final String scriptFolderPath = 'D:/Python Scripts';

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
          const Text('Select a Python script from the list:'),
          DropdownButton<String>(
            value: selectedScript,
            items: pythonScripts.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedScript = newValue;
              });
            },
            hint: const Text('Select a script'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: selectedScript == null ? null : _runSelectedScript,
            child: const Text('Run Selected Script'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: outputController,
            readOnly: true,
            maxLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Script Output',
            ),
          ),
        ],
      ),
    );
  }

  void loadPythonScripts() async {
    final scriptDirectory = Directory(scriptFolderPath);
    List<FileSystemEntity> files = await scriptDirectory.list().toList();
    setState(() {
      pythonScripts = files
          .where((file) => file is File && file.path.endsWith('.py'))
          .map((file) => file.uri.pathSegments.last)
          .toList();
    });
}

  void _runSelectedScript() async {
    if (selectedScript != null) {
      String scriptFullPath = '$scriptFolderPath/${selectedScript!}';
      Process process = await Process.start('python', [scriptFullPath]);

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
          outputController.text += 'Python script execution failed with exit code $exitCode\n';
        });
      }
    }
  }

}