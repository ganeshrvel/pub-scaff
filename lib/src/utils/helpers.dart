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

String replaceExtension(String file, String searchExt, String replaceExt) {
  final _file = file.split('.');

  var newFile = file;
  if (_file[_file.length - 1] == searchExt) {
    _file.removeAt(_file.length - 1);

    newFile = '${_file.join(".")}.${replaceExt}';
  }

  return newFile;
}
