import 'dart:io';
import 'package:dart_scaffold/src/utils/helpers.dart';
import 'package:path/path.dart' as path;
import 'package:mustache/mustache.dart';
import 'package:meta/meta.dart';

class Generator {
  final String sourceDirPath;
  final String destinationDirPath;
  final Map<String, String> scaffoldVariables;
  final String tplExtension;

  final List<String> filesSkipList;

  Generator(
    this.filesSkipList, {
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
    @required this.tplExtension,
  });

  void init() {
    final _destinationDirPath = Directory(destinationDirPath);

    /*if (!_destinationDirPath.existsSync()) {
      print("aaaaaa");
     // _destinationDirPath.createSync();
    }*/

    copyTemplatifiedDirectory(
      Directory(sourceDirPath),
      _destinationDirPath,
    );
  }

  void copyTemplatifiedDirectory(
    Directory source,
    Directory destination,
  ) {
    source.listSync(recursive: false).forEach((var sourceEntity) {
      if (sourceEntity is Directory) {
        final destinationPath = getTemplatifiedDirectoryPath(
          destination.absolute.path,
          scaffoldVariables,
        );
        final sourceEntityPath = getTemplatifiedDirectoryPath(
          sourceEntity.path,
          scaffoldVariables,
        );
        final filePath = path.join(
          destinationPath,
          path.basename(sourceEntityPath),
        );

        final newDirectory = Directory(filePath);

        newDirectory.createSync();

        copyTemplatifiedDirectory(
          sourceEntity.absolute,
          newDirectory,
        );
      } else if (sourceEntity is File) {
        final destinationPath = getTemplatifiedDirectoryPath(
          destination.path,
          scaffoldVariables,
        );
        final sourceEntityPath = getTemplatifiedDirectoryPath(
          sourceEntity.path,
          scaffoldVariables,
        );
        final filePath =
            path.join(destinationPath, path.basename(sourceEntityPath));

        sourceEntity.copySync(filePath);

        processTemplateFiles(filePath);
      }
    });
  }

  void processTemplateFiles(String filePath) {
    final fileContents = File(filePath).readAsStringSync();

    final template = Template(fileContents);

    final output = template.renderString(scaffoldVariables);

    try {
      File(filePath).writeAsStringSync(output);
    } catch (e) {
      rethrow;
    }
  }
}
