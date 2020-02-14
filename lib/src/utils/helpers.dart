String getTemplateStrippedPath(
  String path,
  Map<String, String> scaffoldVariables,
) {
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

bool isFileExtensionMatch(String fileName, String extension) {
  final _fileName = fileName.split('.');

  return _fileName.last == extension;
}

String replaceExtension(String fileName, String searchExt, String replaceExt) {
  final _fileName = fileName.split('.');
  var newFileName = fileName;

  _fileName.removeAt(_fileName.length - 1);

  newFileName = '${_fileName.join(".")}.${replaceExt}';

  return newFileName;
}
