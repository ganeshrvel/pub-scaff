import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mustache/mustache.dart';

void copyTemplatifiedDirectory(Directory source, Directory destination,
    Map<String, String> scaffoldVariables) {
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
        scaffoldVariables,
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

      processTemplateFiles(filePath, scaffoldVariables);
    }
  });
}

String getTemplatifiedDirectoryPath(
    String path, Map<String, String> scaffoldVariables) {
  var _path = path;

  scaffoldVariables.forEach((key, value) {
    if (path.contains('{{${key}}}')) {
      _path = _path.replaceAll(
        '{{${key}}}',
        value,
      );
    }
  });

  return _path;
}

void processTemplateFiles(
    String filePath, Map<String, String> scaffoldVariables) {
  var fileContents = File(filePath).readAsStringSync();

  var template = Template(fileContents);

  var output = template.renderString(scaffoldVariables);

  try {
    File(filePath).writeAsStringSync(output);
  } catch (e) {
    rethrow;
  }
}
