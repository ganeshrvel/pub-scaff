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

  Generator({
    @required this.sourceDirPath,
    @required this.destinationDirPath,
    @required this.scaffoldVariables,
    @required this.tplExtension,
  });

  void init() {
    copyTemplatifiedDirectory(
      Directory(sourceDirPath),
      Directory(destinationDirPath),
    );
  }

  void copyTemplatifiedDirectory(
    Directory source,
    Directory destination,
  ) {
    source.listSync(recursive: false).forEach((var sourceEntity) {
      if (sourceEntity is Directory) {
        var destinationPath = getTemplatifiedDirectoryPath(
          destination.absolute.path,
          scaffoldVariables,
        );
        var sourceEntityPath = getTemplatifiedDirectoryPath(
          sourceEntity.path,
          scaffoldVariables,
        );
        var filePath = path.join(
          destinationPath,
          path.basename(sourceEntityPath),
        );

        var newDirectory = Directory(filePath);

        newDirectory.createSync();

        copyTemplatifiedDirectory(
          sourceEntity.absolute,
          newDirectory,
        );
      } else if (sourceEntity is File) {
        var destinationPath = getTemplatifiedDirectoryPath(
          destination.path,
          scaffoldVariables,
        );
        var sourceEntityPath = getTemplatifiedDirectoryPath(
          sourceEntity.path,
          scaffoldVariables,
        );
        var filePath =
            path.join(destinationPath, path.basename(sourceEntityPath));

        sourceEntity.copySync(filePath);

        processTemplateFiles(filePath);
      }
    });
  }

  void processTemplateFiles(String filePath) {
    var fileContents = File(filePath).readAsStringSync();

    var template = Template(fileContents);

    var output = template.renderString(scaffoldVariables);

    try {
      File(filePath).writeAsStringSync(output);
    } catch (e) {
      rethrow;
    }
  }
}
