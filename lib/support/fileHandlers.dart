import 'package:blueframe/blueframe.dart';
import 'dart:io' as io;
import 'package:mime/mime.dart' as mime;

Future<Response> getJsMinFile(Request request)async {
  try{
    String path = "js/js-min/${request.path.segments.join("/")}";
    path = path.replaceAll(".js", ".min.js");
    final f = File(path);
    return Response.ok(
        f.readAsBytesSync())
      ..contentType = io.ContentType.parse(mime.lookupMimeType(f.path));
  } catch (e) {
    return Response.notFound();
  }
}

Future<Response> getIcoFile(Request request) async {
  try {
    final String filePath = "assets/${request.path.segments.join("/")}";
    final file = File(filePath);
    final fileContents = file.readAsBytesSync();
    final contentType = mime.lookupMimeType(filePath);
    return Response.ok(fileContents)
      ..contentType = io.ContentType.parse(contentType);
  } catch (e){
    return Response.notFound();
  }
}