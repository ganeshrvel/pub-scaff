import 'dart:io';
import 'package:path/path.dart' as path;

void copyTemplatifiedDirectory(Directory source, Directory destination,
    List<Map<String, String>> scaffoldVariables) {
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

      var newDirectory = Directory(
        path.join(
          destinationPath,
          path.basename(sourceEntityPath),
        ),
      );

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

      sourceEntity.copySync(
        path.join(destinationPath, path.basename(sourceEntityPath)),
      );
    }
  });
}

String getTemplatifiedDirectoryPath(
  String path,
  List<Map<String, String>> scaffoldVariables,
) {
  var _return = path;

  scaffoldVariables.forEach((a) {
    var key = a.keys.toList()[0];
    var value = a.values.toList()[0];

    if (path.contains('{{${key}}}')) {
      _return = _return.replaceAll(
        '{{${key}}}',
        value,
      );
    }
  });

  return _return;
}
