import 'dart:io';
import 'package:scaff/src/utils/helpers.dart';
import 'package:path/path.dart' as path;
import 'package:mustache/mustache.dart';
import 'package:meta/meta.dart';

///
/// Generator Class
/// Copy files and process template files to final output
///

class Generator {
  final String sourceDirPath;
  final String destinationDirPath;
  final Map<String, String> scaffoldVariables;
  final String tplExtension;
  final String setupConfigFilePath;
  final List<String> filesSkipList = [];

  Generator({
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
    @required this.tplExtension,
    @required this.setupConfigFilePath,
  }) {
    filesSkipList.add(setupConfigFilePath);
  }

  void init() {
    final _sourceDirPath = Directory(sourceDirPath);
    final _destinationDirPath = Directory(destinationDirPath);

    /// create the destination dir if not found
    if (!_destinationDirPath.existsSync()) {
      _destinationDirPath.createSync(recursive: true);
    }

    copyTemplatifiedDirectory(
      _sourceDirPath,
      _destinationDirPath,
    );
  }

  /// Recursively copy files from source to destination folder

  void copyTemplatifiedDirectory(
    Directory source,
    Directory destination,
  ) {
    source.listSync(recursive: false).forEach((final sourceEntity) {
      // prevent recursive creation of the destination dir
      // prevent setupConfigFilePath from writing to the destination
      if (sourceEntity.absolute.path != destination.absolute.path &&
          path.join(sourceDirPath, setupConfigFilePath) != sourceEntity.path) {
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
        }
        /// File copying logic
        else if (sourceEntity is File) {
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

  /// Replace scaffold variables with values from cli prompt
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
