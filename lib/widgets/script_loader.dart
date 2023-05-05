import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> loadPythonScripts() async {
  const String scriptFolderPath = 'assets/python_scripts';
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final scriptPaths = manifestMap.keys
      .where((String key) => key.startsWith(scriptFolderPath) && key.endsWith('.py'))
      .toList();

  return scriptPaths.map((path) => path.split('/').last).toList();
}
