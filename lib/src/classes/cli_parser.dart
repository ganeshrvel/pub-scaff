import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:io/ansi.dart';
import 'package:meta/meta.dart';
import 'package:prompts/prompts.dart' as prompts;

import '../constants.dart';

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

  CliParser({
    @required this.cwd,
    @required this.destPath,
  });

  Future<CliStream> getCliStream() async {
    var sourceDir = prompts.get('Enter source directory', defaultsTo: cwd);
    var destinationDirPath =
        prompts.get('Enter destination directory', defaultsTo: this.destPath);

    final setupFile =
        await File(path.join(cwd /*sourceDir*/, SETUP_CONFIG_FILE));
    if (!setupFile.existsSync()) {
      throw '${SETUP_CONFIG_FILE} was not found inside the source directory.';
    }

    final setupJson = jsonDecode(setupFile.readAsStringSync());

    if (setupJson['variables'] == null) {
      throw "'variables' list not found inside ${SETUP_CONFIG_FILE}";
    }

    final setupFileScaffoldVars = setupJson['variables'];

    final scaffoldVarMap = HashMap<String, String>();

    for (final e in setupFileScaffoldVars) {
      final varValue = prompts.get('Enter ${e} variable value');

      scaffoldVarMap.putIfAbsent(e, () => varValue);
    }

    return CliStream(
      sourceDirPath: sourceDir,
      destinationDirPath: destinationDirPath,
      scaffoldVariables: scaffoldVarMap,
    );
  }
}
