import 'package:io/ansi.dart';
import 'package:meta/meta.dart';
import 'package:prompts/prompts.dart' as prompts;

class CliStream {
  String sourceDir;
  String destinationDirPath;

  CliStream({
    @required this.sourceDir,
    @required this.destinationDirPath,
  });
}

class CliParser {
  final cwd;
  final destinationDirPath;

  CliParser({
    @required this.cwd,
    @required this.destinationDirPath,
  });

  CliStream getCliStream() {
    var sourceDir = prompts.get('Enter source directory', defaultsTo: cwd);
    var destinationDirPath = prompts.get('Enter destination directory',
        defaultsTo: this.destinationDirPath);

    return CliStream(
      sourceDir: sourceDir,
      destinationDirPath: destinationDirPath,
    );
  }
}
