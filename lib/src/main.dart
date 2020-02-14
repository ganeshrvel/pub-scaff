import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dart_scaffold/src/classes/cli_parser.dart';
import 'package:dart_scaffold/src/classes/generator.dart';
import 'package:dart_scaffold/src/constants.dart';

Future<void> main() async {
  // @todo rename files to dart
  // @todo check if source directory exists

  final cwd = Directory.current.path;
  final destinationDirPath = path.join(cwd, '__components__');
  final tplExtension = TPL_FILES_EXTENSION;

  final cli = CliParser(
    cwd: cwd,
    destPath: destinationDirPath,
  );

  final cliStream = await cli.getCliStream();

  print(cliStream.sourceDirPath);
  print(cliStream.destinationDirPath);
  print(cliStream.scaffoldVariables);

  final generator = Generator(
    sourceDirPath: cliStream.sourceDirPath,
    destinationDirPath: cliStream.destinationDirPath,
    scaffoldVariables: cliStream.scaffoldVariables,
    tplExtension: tplExtension,
  );

  generator.init();
}
