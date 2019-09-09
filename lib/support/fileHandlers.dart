import 'package:blueframe/blueframe.dart';
import 'dart:io' as io;
import 'package:mime/mime.dart' as mime;

class FileHandlers {
// ignore: non_constant_identifier_names
	static Future<Response> JsMin(Request request) async =>
		await getFileResponse(
			"js/js-min/${request.path.segments.join("/").replaceFirst(
				".js", ".min.js")}");

// ignore: non_constant_identifier_names
	static Future<Response> Js(Request request) async =>
		await getFileResponse("js/js/${request.path.segments.join("/")}");

// ignore: non_constant_identifier_names
	static Future<Response> Css(Request request) async =>
		await getFileResponse("assets/css/${request.path.segments.join("/")}");

// ignore: non_constant_identifier_names
	static Future<Response> Ico(Request request) async =>
		await getFileResponse("assets/${request.path.segments.join("/")}");

	static Future<Response> getFileResponse(String path) async {
		try {
			final file = File(path);
			final fileContents = await file.readAsBytes();
			final contentType = mime.lookupMimeType(path);
			return Response.ok(fileContents)
				..contentType = io.ContentType.parse(contentType);
		} catch (e) {
			print(e);
			return Response.notFound();
		}
	}


}