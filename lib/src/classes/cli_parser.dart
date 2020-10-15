import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';
import 'package:prompts/prompts.dart' as prompts;

/// CliStream Model Class
class CliStream {
  final String sourceDirPath;
  final String destinationDirPath;
  final Map<String, String> scaffoldVariables;
  final String tplExtension;

  CliStream({
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
    @required this.tplExtension,
  });
}

/// CliParser Class
/// Accepts inputs from the CLI prompt, processes them and returns the inputted data.
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

  /// Find the template extension
  String getTemplateExtension(String tplExtension) {
    final _tplSplitList = tplExtension.split('.');

    if (_tplSplitList[0].isEmpty) {
      _tplSplitList.removeAt(0);
    }

    return _tplSplitList.join('.');
  }

  /// Get the CLI stream
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

    final _setupJson = jsonDecode(setupFilePath.readAsStringSync());
    final _setupJsonVariables = _setupJson['variables'] as List<dynamic>;
    final _setupJsonMappedVariables =
        _setupJson['mappedVariables'] as Map<dynamic, dynamic>;

    if (_setupJsonVariables == null && _setupJsonMappedVariables == null) {
      throw "either 'variables' or 'mappedVariables' should be available inside the $setupConfigFilePath file.";
    }

    final _scaffoldVariables = List<String>.from(_setupJsonVariables ?? []);
    final _scaffoldMappedVariables =
        Map<String, String>.from(_setupJsonMappedVariables ?? {});

    final _scaffoldVarMap = <String, String>{
      ..._scaffoldMappedVariables ?? {},
    };

    for (final e in _scaffoldVariables) {
      if (_scaffoldVarMap.containsKey(e)) {
        continue;
      }

      final varValue = prompts.get("Enter '$e' variable value");

      _scaffoldVarMap.putIfAbsent(e, () => varValue);
    }

    return CliStream(
      sourceDirPath: sourceDir,
      destinationDirPath: destinationDir,
      scaffoldVariables: _scaffoldVarMap,
      tplExtension: getTemplateExtension(tplExtension),
    );
  }
}
