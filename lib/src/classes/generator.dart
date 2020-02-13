import 'dart:io';

import 'package:dart_scaffold/src/utils/fileops.dart';
import 'package:meta/meta.dart';

class Generator {
  final String cwd;
  final String copyToDirPath;
  final Map<String, String> scaffoldVariables;

  Generator({
    @required this.cwd,
    @required this.copyToDirPath,
    @required this.scaffoldVariables,
  });

  void init() {
    copyTemplatifiedDirectory(
        Directory(cwd), Directory(copyToDirPath), scaffoldVariables);
  }
}
