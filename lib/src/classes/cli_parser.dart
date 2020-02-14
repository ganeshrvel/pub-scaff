import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';
import 'package:prompts/prompts.dart' as prompts;

///
/// CliStream Model Class
///

class CliStream {
  String sourceDirPath;
  String destinationDirPath;
  HashMap<String, String> scaffoldVariables;

  CliStream({
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
  });
}

///
/// CliParser Class
/// Accepts inputs from the CLI prompt, processes them and returns the inputted data.
///

class CliParser {
  final String cwd;
  final String destPath;
  final String setupConfigFilePath;

  CliParser({
    @required this.cwd,
    @required this.destPath,
    @required this.setupConfigFilePath,
  });

  Future<CliStream> getCliStream() async {
    var sourceDir = prompts.get('Enter source directory', defaultsTo: cwd);
    var destinationDir =
        prompts.get('Enter destination directory', defaultsTo: destPath);

    if (!Directory(sourceDir).existsSync()) {
      throw 'Source directory does not exist.';
    }

    final setupFilePath = await File(path.join(sourceDir, setupConfigFilePath));
    if (!setupFilePath.existsSync()) {
      throw '${setupConfigFilePath} was not found inside the source directory.';
    }

    final setupJson = jsonDecode(setupFilePath.readAsStringSync());

    if (setupJson['variables'] == null) {
      throw "'variables' list not found inside ${setupConfigFilePath}.";
    }

    final setupFileScaffoldVars = setupJson['variables'];

    final scaffoldVarMap = HashMap<String, String>();

    for (final e in setupFileScaffoldVars) {
      final varValue = prompts.get("Enter '${e}' variable value");

      scaffoldVarMap.putIfAbsent(e, () => varValue);
    }

    return CliStream(
      sourceDirPath: sourceDir,
      destinationDirPath: destinationDir,
      scaffoldVariables: scaffoldVarMap,
    );
  }
}
