import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:scaff/src/classes/cli_parser.dart';
import 'package:scaff/src/classes/generator.dart';
import 'package:scaff/src/constants.dart';

/// The action begins here
Future<void> main() async {
  final cwd = Directory.current.path;
  final destinationDirPath = path.join(cwd, TEMP_DESTINATION_DIRECTORY);
  const tplExtension = TPL_FILES_EXTENSION;
  const setupConfigFilePath = SETUP_CONFIG_FILE;

  final cli = CliParser(
    cwd: cwd,
    destPath: destinationDirPath,
    setupConfigFilePath: setupConfigFilePath,
    tplExt: tplExtension,
  );

  final cliStream = await cli.getCliStream();

  final generator = Generator(
    sourceDirPath: cliStream.sourceDirPath,
    destinationDirPath: cliStream.destinationDirPath,
    scaffoldVariables: cliStream.scaffoldVariables,
    tplExtension: cliStream.tplExtension,
    setupConfigFilePath: setupConfigFilePath,
  );

  generator.init();
}
