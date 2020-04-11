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
  final String sourceDirPath;
  final String destinationDirPath;
  final HashMap<String, String> scaffoldVariables;
  final String tplExtension;

  CliStream({
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
    @required this.tplExtension,
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
  final String tplExt;

  CliParser({
    @required this.cwd,
    @required this.destPath,
    @required this.setupConfigFilePath,
    @required this.tplExt,
  });

  String getTemplateExtension(String tplExtension) {
    final _tplSplitList = tplExtension.split('.');

    if (_tplSplitList[0].isEmpty) {
      _tplSplitList.removeAt(0);
    }

    return _tplSplitList.join('.');
  }

  Future<CliStream> getCliStream() async {
    final sourceDir = prompts.get('Enter source directory', defaultsTo: cwd);
    final destinationDir =
        prompts.get('Enter destination directory', defaultsTo: destPath);

    if (!Directory(sourceDir).existsSync()) {
      throw 'Source directory does not exist.';
    }

    final setupFilePath = File(path.join(sourceDir, setupConfigFilePath));
    if (!setupFilePath.existsSync()) {
      throw '$setupConfigFilePath was not found inside the source directory.';
    }

    final tplExtension =
        prompts.get('Enter template extension', defaultsTo: tplExt);

    if (tplExtension == null || tplExtension.isEmpty) {
      throw 'Invalid template extension';
    }

    final setupJson = jsonDecode(setupFilePath.readAsStringSync());
    if (setupJson['variables'] == null) {
      throw "'variables' list not found inside $setupConfigFilePath.";
    }

    final setupFileScaffoldVars = setupJson['variables'] as List<String>;

    final scaffoldVarMap = HashMap<String, String>();

    for (final e in setupFileScaffoldVars) {
      final varValue = prompts.get("Enter '$e' variable value");

      scaffoldVarMap.putIfAbsent(e, () => varValue);
    }

    return CliStream(
      sourceDirPath: sourceDir,
      destinationDirPath: destinationDir,
      scaffoldVariables: scaffoldVarMap,
      tplExtension: getTemplateExtension(tplExtension),
    );
  }
}
