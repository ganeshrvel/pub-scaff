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
