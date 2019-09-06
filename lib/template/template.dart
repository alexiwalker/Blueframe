import "dart:io";
import 'package:blueframe/blueframe.dart';

class Template {
  Template({this.replacers, this.template, basePath, this.replaceIteratively}) {
    if (basePath != "") this.basePath += "$basePath\\";
    try {
      final File f = File("${this.basePath}$template");
      _templateContents = f.readAsStringSync();
    } catch (e) {
      print(e.toString());
      _templateContents = "";
    }
  }

  String get content {
    return _templateContents;
  }

  Map<String, String> replacers;

  String template;
  String _templateContents;
  String basePath = "";
  String errString = "";
  bool replaceIteratively = false;

  List<String> includedFiles = [];

  final RegExp includePattern = RegExp(r'({{@include\s\"[A-Za-z0-9.\\\/]+\"}})', caseSensitive: true);
  final RegExp includeOncePattern = RegExp(r'({{@includeonce\s\"[A-Za-z0-9.\\\/]+\"}})', caseSensitive: true);
  final RegExp replacersPattern = RegExp(r'(\[\[[A-Za-z0-9]+]\])', caseSensitive: true);
  final RegExp filenamesPattern = RegExp(r'(\"[A-Za-z0-9.\\\/]+\")', caseSensitive: true);

  void setReplacers(Map<String, String> replacers) {
    this.replacers = replacers;
  }

  void setViewRoute(String path) {
    basePath = path;
  }

  void setTemplate(String template) {
    this.template = template;

    try {
      final File file = File("$basePath/$this.template");
      _templateContents = file.readAsStringSync();
    } catch (e) {
      print(e.toString());

      _templateContents = "";
    }
  }

  ///
  /// Replacers are denoted by [[]] in the .dtp file
  /// they are casesensitive
  ///
  void runReplacers() {
    for (var pair in replacers.entries) {
      final String key = pair.key;
      final String content = pair.value;
      final String formatter = "(\\[\\[$key\\]\\])";
      _templateContents = _templateContents.replaceAllMapped(RegExp(formatter, caseSensitive: false), (Match m) => content);
    }
  }

  ///
  /// Attempts to replace all replacerfields so long as they exist
  /// this may be desired where the replcers list values itself contains more replacers, leaving [[field]] after the first pass
  ///
  void replaceIterative() {
    String start;
    while (hasReplacers()) {
      start = _templateContents;
      for (var pair in replacers.entries) {
        final String key = pair.key;
        final String content = pair.value;
        final String formatter = "(\\[\\[$key\\]\\])";
        _templateContents = _templateContents.replaceAllMapped(RegExp(formatter, caseSensitive: false), (Match m) => content);
      }

      //if a pass results in no change to the document, break the loop
      //the while relies in [[field]] formatted statements, but if the key doesn't exist
      //it will always return true, and would cause an inf loop if not a rtn or brk here
      if (_templateContents == start)
        return;
    }
  }

  ///
  /// currently directives only includes... includes
  /// it will contain more complicated functions/tags in the future
  ///
  /// Directives are denoted by {{}} in the .dtp file
  ///
  void runDirectives() {
    runIncludes();
    runIncludeOnce();
  }

  ///
  /// Format: {{@include "filename.js"}}
  ///
  void runIncludes() {
    while (hasIncludes()) {
      _templateContents = _templateContents.replaceAllMapped(includePattern, (Match m) {
        String filename = filenamesPattern.firstMatch(m.group(0)).group(0);
        filename = filename.replaceAll("\"", "");
        String fileContent;
        try {
          final File file = File("$basePath$filename");
          fileContent = file.readAsStringSync();
        } catch (e) {
          print(e.toString());
          return errString;
        }
        return fileContent;
      });
    }
  }

  ///
  /// any includeonce files are only included once per Template object, based on a List<String> of included filenames
  ///
  /// this may be bypassed by creating a second template object, rendering it to get contents and then appending those contents to another
  /// ...although if you need to do that, maybe just use @include instead of @includeonce
  ///
  /// Format: {{@includeonce "filename.js"}}
  ///
  void runIncludeOnce() {
    while (hasIncludeOnce()) {
      _templateContents = _templateContents.replaceAllMapped(includeOncePattern, (Match m) {
        String filename = filenamesPattern.firstMatch(m.group(0)).group(0);
        filename = filename.replaceAll("\"", "");

        if (includedFiles.contains(filename))
          return "";
        else
          includedFiles.add(filename);

        String fileContent;
        try {
          final File file = File("$basePath$filename");
          fileContent = file.readAsStringSync();
        } catch (e) {
          print(e.toString());
          return errString;
        }
        return fileContent;
      });
    }
  }

  void appendFile(String filename) {
    try {
      final File file = File("$basePath/$filename");
      final String content = file.readAsStringSync();
      _templateContents += "\n$content";
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  bool hasIncludes() => includePattern.hasMatch(_templateContents);

  bool hasIncludeOnce() => includeOncePattern.hasMatch(_templateContents);

  bool hasReplacers() => replacersPattern.hasMatch(_templateContents);

  void render() {
    replaceIteratively ? replaceIterative() : runReplacers();
    runDirectives();
  }
}
