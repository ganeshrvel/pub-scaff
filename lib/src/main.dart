import 'package:dart_scaffold/src/classes/generator.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

void main() {
  final cwd = Directory.current.path;
  final copyFromDirPath = path.join(cwd, 'mocks');
  final copyToDirPath = path.join(cwd, 'temp');
  final scaffoldVariables = {'page': 'Demo', 'title': 'AppDemo'};
  final tplExtension = 'tpl';

  final generator = Generator(
    cwd: copyFromDirPath,
    copyToDirPath: copyToDirPath,
    scaffoldVariables: scaffoldVariables,
    tplExtension: tplExtension,
  );

  generator.init();
}
