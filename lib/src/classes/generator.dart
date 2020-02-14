import 'dart:io';
import 'package:scaff/src/utils/helpers.dart';
import 'package:path/path.dart' as path;
import 'package:mustache/mustache.dart';
import 'package:meta/meta.dart';

class Generator {
  final String sourceDirPath;
  final String destinationDirPath;
  final Map<String, String> scaffoldVariables;
  final String tplExtension;
  final String setupConfigFile;

  final List<String> filesSkipList = [];

  Generator({
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
    @required this.tplExtension,
    @required this.setupConfigFile,
  }) {
    filesSkipList.add(setupConfigFile);
  }

  void init() {
    final _sourceDirPath = Directory(sourceDirPath);
    final _destinationDirPath = Directory(destinationDirPath);

    if (!_destinationDirPath.existsSync()) {
      _destinationDirPath.createSync(recursive: true);
    }

    copyTemplatifiedDirectory(
      _sourceDirPath,
      _destinationDirPath,
    );
  }

  void copyTemplatifiedDirectory(
    Directory source,
    Directory destination,
  ) {
    source.listSync(recursive: false).forEach((final sourceEntity) {
      // prevent recursive creation of the destination dir
      // prevent setupConfigFile from writing to the destination
      if (sourceEntity.absolute.path != destination.absolute.path &&
          path.join(sourceDirPath, setupConfigFile) != sourceEntity.path) {
        if (sourceEntity is Directory) {
          final destinationPath = getTemplateStrippedPath(
            destination.absolute.path,
            scaffoldVariables,
          );
          final sourceEntityPath = getTemplateStrippedPath(
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
          final destinationPath = getTemplateStrippedPath(
            destination.path,
            scaffoldVariables,
          );
          final sourceEntityPath = getTemplateStrippedPath(
            sourceEntity.path,
            scaffoldVariables,
          );

          final fileName = replaceExtension(
            sourceEntityPath,
            tplExtension,
            'dart',
          );

          final filePath = path.join(
            destinationPath,
            path.basename(fileName),
          );

          sourceEntity.copySync(filePath);

          processTemplateFiles(filePath);
        }
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
