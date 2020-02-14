import 'package:dart_scaffold/src/classes/cli_parser.dart';
import 'package:dart_scaffold/src/classes/generator.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

void main() {
  final cwd = Directory.current.path;
  final destinationDirPath = path.join(cwd, '__components__');

  final sourceDirPath = path.join(cwd, 'mocks');
  final _destinationDirPath = path.join(cwd, 'temp');
  final scaffoldVariables = {'page': 'Demo', 'title': 'AppDemo'};
  final tplExtension = 'tpl';

  final cli = CliParser(
    cwd: cwd,
    destinationDirPath: destinationDirPath,
  );
  var cliStream = cli.getCliStream();

  print(cliStream.sourceDir);
  print(cliStream.destinationDirPath);

  /*final generator = Generator(
    cwd: sourceDirPath,
    destinationDirPath: destinationDirPath,
    scaffoldVariables: scaffoldVariables,
    tplExtension: tplExtension,
  );

  generator.init();*/
}
