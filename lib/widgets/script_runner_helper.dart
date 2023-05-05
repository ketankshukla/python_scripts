import 'dart:convert';
import 'dart:io';

Future<Map<String, String>> runSelectedScript(
    String scriptFolderPath, String selectedScript, String folderPathToPass) async {
  String scriptFullPath = '$scriptFolderPath/$selectedScript';
  Process process = await Process.start('python', [scriptFullPath, folderPathToPass]);

  StringBuffer outputBuffer = StringBuffer();
  StringBuffer errorBuffer = StringBuffer();

  process.stdout.transform(utf8.decoder).listen((data) {
    outputBuffer.writeln('stdout: $data');
  });

  process.stderr.transform(utf8.decoder).listen((data) {
    errorBuffer.writeln('stderr: $data');
  });

  int exitCode = await process.exitCode;
  if (exitCode == 0) {
    outputBuffer.writeln('Python script executed successfully');
  } else {
    errorBuffer.writeln('Python script execution failed with exit code $exitCode');
  }

  return {
    'output': outputBuffer.toString(),
    'error': errorBuffer.toString(),
  };
}
