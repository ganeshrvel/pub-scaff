import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';
import 'package:prompts/prompts.dart' as prompts;

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

class CliParser {
  final String cwd;
  final String destPath;
  final String setupConfigFile;

  CliParser({
    @required this.cwd,
    @required this.destPath,
    @required this.setupConfigFile,
  });

  Future<CliStream> getCliStream() async {
    var sourceDir = prompts.get('Enter source directory', defaultsTo: cwd);
    var destinationDirPath =
        prompts.get('Enter destination directory', defaultsTo: destPath);

    final setupFile = await File(path.join(sourceDir, setupConfigFile));
    if (!setupFile.existsSync()) {
      throw '${setupConfigFile} was not found inside the source directory.';
    }

    final setupJson = jsonDecode(setupFile.readAsStringSync());

    if (setupJson['variables'] == null) {
      throw "'variables' list not found inside ${setupConfigFile}";
    }

    final setupFileScaffoldVars = setupJson['variables'];

    final scaffoldVarMap = HashMap<String, String>();

    for (final e in setupFileScaffoldVars) {
      final varValue = prompts.get("Enter '${e}' variable value");

      scaffoldVarMap.putIfAbsent(e, () => varValue);
    }

    return CliStream(
      sourceDirPath: sourceDir,
      destinationDirPath: destinationDirPath,
      scaffoldVariables: scaffoldVarMap,
    );
  }
}
