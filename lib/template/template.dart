import "dart:io";

import 'package:blueframe/blueframe.dart';

class Template {
  Template({this.replacers, this.template, basePath}) {
    if(basePath != "")
      this.basePath+="$basePath\\";
    final File f = File("${this.basePath}$template");
    _templateContents = f.readAsStringSync();
  }

  Map<String, String> replacers;
  String template;
  String _templateContents;

  String errString = "";

  void setReplacers(Map<String, String> replacers) {
    this.replacers = replacers;
  }

  String basePath = "";
  void setViewRoute(String fpath){
    basePath = fpath;
  }

  void setTemplate(String template) {
    this.template = template;
    File f = File("$basePath/$this.template");
    _templateContents = f.readAsStringSync();
  }

  void runReplacers() {
    for (var pair in replacers.entries) {
      final String key = pair.key;
      final String content = pair.value;
      print(content);
      final String formatter = "(\\[\\[$key\\]\\])";
      _templateContents = _templateContents.replaceAllMapped(RegExp(formatter, caseSensitive: false), (Match m) => content);
    }
  }

  final RegExp includes = RegExp(r'({{@include\s\"[A-Za-z0-9.\\\/]+\"}})', caseSensitive: true);

  void runDirectives() {
    String intermediate = _templateContents;
    while (hasIncludes()) {
      intermediate = intermediate.replaceAllMapped(includes, (Match m) {
        String filename = RegExp(r'(\"[A-Za-z0-9.\\\/]+\")').firstMatch(m.group(0)).group(0);
        filename = filename.replaceAll("\"", "");
        String fileContent;
        try {
          print("$basePath$filename");
          final File file = File("$basePath$filename");
          fileContent = file.readAsStringSync();
        } catch (e) {
          return errString;
        }
        return fileContent;
      });

      _templateContents = intermediate;
    }
  }


  String getContents() {
    return _templateContents;
  }

  ///
  /// If you need to combine two or more files as the template base, use appendFile(filename) to add a file onto the end
  ///
  void appendFile(String filename) {
    try {
      final File f = File( "$basePath/$filename");
      final String content = f.readAsStringSync();
      _templateContents += "\n$content";
    } catch (e) {
      return;
    }
  }

  bool hasIncludes() => includes.hasMatch(_templateContents);
  
}
